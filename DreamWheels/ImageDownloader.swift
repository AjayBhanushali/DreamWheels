//
//  ImageDownloader.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/12/20.
//

import Foundation
import UIKit

typealias ImageDownloadCompletionHander = ((UIImage?, Bool?, URL, Error?) -> Void)

final class ImageDownloader {
    
    /// Chache for images
    private let imageCache = NSCache<NSString, UIImage>()
    private let network: NetworkService = NetworkAPI()
    
    /// Operation Queue for downloading images
    lazy var downloadQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.async.image.downloadQueue"
        queue.maxConcurrentOperationCount = 4
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    /// shared instance
    static let shared = ImageDownloader()
   
    private init() {}
    
    /// Download image keeping caches
    /// - Parameters:
    ///   - imageURL: URL
    ///   - size: Size
    ///   - scale: Scale
    ///   - indexPath: IndexPath
    ///   - completion: Completion Handler
    func downloadImage(withURL imageURL: URL, size: CGSize, scale: CGFloat = UIScreen.main.scale, completion: @escaping ImageDownloadCompletionHander) {
        
        /// Check for image in cache
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            completion(cachedImage, true, imageURL, nil)
            /// If image is getting downloaded then set its priority to high
        } else if let existingImageOperations = downloadQueue.operations as? [ImageOperation],
            let imgOperation = existingImageOperations.first(where: {
                return ($0.imageURL == imageURL) && $0.isExecuting && !$0.isFinished
            }) {
            imgOperation.queuePriority = .high
            /// Else create a new operation and add it in the queue
        } else {
            let imageOperation = ImageOperation(imageURL: imageURL, size: size, scale: scale, network: network)
            imageOperation.queuePriority = .veryHigh
            imageOperation.imageDownloadCompletionHandler = { [unowned self] result in
                switch result {
                case let .success(image):
                    self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
                    completion(image, false, imageURL, nil)
                case let .failure(error):
                    completion(nil, false, imageURL, error)
                }
            }
            downloadQueue.addOperation(imageOperation)
        }
    }
    
    /// Used when items is in the queue but prioity needs to be decreased
    /// - Parameter imageURL: URL for image
    func changeDownloadPriority(for imageURL: URL) {
        guard let ongoingImageOperations = downloadQueue.operations as? [ImageOperation] else {
            return
        }
        let imageOperations = ongoingImageOperations.filter {
            $0.imageURL.absoluteString == imageURL.absoluteString && $0.isFinished == false && $0.isExecuting == true
        }
        guard let operation = imageOperations.first else {
            return
        }
        operation.queuePriority = .low
    }
    
    /// Can all the operations in the queue
    func cancelAll() {
        downloadQueue.cancelAllOperations()
    }
    
    /// To cancel a specific operation
    /// - Parameter imageUrl: URL
    func cancelOperation(imageUrl: URL) {
        if let imageOperations = downloadQueue.operations as? [ImageOperation],
            let operation = imageOperations.first(where: { $0.imageURL == imageUrl }) {
            operation.cancel()
        }
    }
}
