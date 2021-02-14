//
//  NetworkClientMock.swift
//  DreamWheelsTests
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation
import UIKit
@testable import DreamWheels

final class NetworkClientMock: NetworkService {
    func downloadRequest(_ url: URL, size: CGSize, scale: CGFloat, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask {
        return URLSessionDownloadTask()
    }
    
    
    func dataRequest<T>(_ endPoint: NetworkAPIEndPoint, objectType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask where T : Decodable {
        if case DreamWheelsAPI.getManufacturersFor(page: 0) = endPoint {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "Manufacturers0", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            let json = try! JSONDecoder().decode(objectType, from: data)
            completion(Result.success(json))
        } else if case DreamWheelsAPI.getManufacturersFor(page: 1) = endPoint {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "Manufacturers1", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            let json = try! JSONDecoder().decode(objectType, from: data)
            completion(Result.success(json))
        } else if case DreamWheelsAPI.getManufacturersFor(page: -1) = endPoint {
            completion(Result.failure(.invalidStatusCode(401)))
        } else if case DreamWheelsAPI.getModelsFor(manufacturId: "130", page: 0) = endPoint {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "BMWModels", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            let json = try! JSONDecoder().decode(objectType, from: data)
            completion(Result.success(json))
        } else if case DreamWheelsAPI.getModelsFor(manufacturId: "INVALID", page: 0) = endPoint {
            completion(Result.failure(.emptyData))
        }
        return URLSessionDataTask()
    }
    
}

