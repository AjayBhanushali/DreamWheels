//
//  NetworkAPI.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/12/20.
//

import Foundation
import UIKit

/// Network API Class conforming to NetworkService protocols
final class NetworkAPI: NetworkService {
    
    private let session: URLSession
    
    /// to keep shared instance
    static var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        if #available(iOS 11.0, *) {
            configuration.waitsForConnectivity = true
        }
        return URLSession(configuration: configuration)
    }()
    
    /// using shared instance by default
    /// - Parameter session: session
    init(session: URLSession = NetworkAPI.defaultSession) {
        self.session = session
    }

    //MARK: DataRequest
    /// A method responsible for Data task
    /// - Parameters:
    ///   - endPoint: NetworkAPIEndPoint // can be helpful in case of any changes
    ///   - objectType: Type required in the return
    ///   - completion: completion handler with Result
    /// - Returns: URLSession Data Task
    @discardableResult
    func dataRequest<T: Decodable>(_ endPoint: NetworkAPIEndPoint, objectType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        
        /// To check if the given request is valid or not
        var request: URLRequest
        do {
            request = try endPoint.asURLRequest()
        } catch {
            completion(.failure(error as! NetworkError))
            return URLSessionDataTask()
        }

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                completion(Result.failure(NetworkError.apiError(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(Result.failure(NetworkError.emptyData))
                return
            }
            guard response.statusCode == 200 else {
                completion(Result.failure(NetworkError.invalidStatusCode(response.statusCode)))
                return
            }
            
            // self.printJSON(data: data)
            // If parsing is successful call completion handler with success result
            do {
                let jsonObject = try JSONDecoder().decode(objectType, from: data)
                completion(Result.success(jsonObject))
            } catch {
                completion(Result.failure(NetworkError.decodingError(error as! DecodingError)))
            }
        }
        // To start the task
        dataTask.resume()
        
        return dataTask
    }

    //MARK: DataRequest
    /// A method for download task
    /// - Parameters:
    ///   - url: URL
    ///   - size: SIze of the image
    ///   - scale: scale of the iamge
    ///   - completion: completion handler with Result
    /// - Returns: URLSessionDownloadTask
    @discardableResult
    func downloadRequest(_ url: URL, size: CGSize, scale: CGFloat, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask {
        let downloadTask = self.session.downloadTask(with: url) { (location: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(.apiError(error)))
                return
            }
            guard let location = location else {
                completion(Result.failure(.emptyData))
                return
            }
            guard let downloadedImage = self.downsampleImage(from: location, pointSize: size, scale: scale) else {
                if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.emptyData))
                }
                return
            }
            completion(.success(downloadedImage))
        }
        downloadTask.resume()
        return downloadTask
    }
    
    //MARK: Downsample Image to given Size
    private func downsampleImage(from url: URL, pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
            return nil
        }
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
             kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        return UIImage(cgImage: downSampledImage)
    }
}


extension NetworkAPI {
    /// To print JSON data
    /// - Parameter data: JSON Data
    func printJSON(data: Data) {
        let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = String.init(data: jsonData, encoding: .utf8)
        print(string ?? "NIL")
    }
}
