//
//  DreamWheelsAPI.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import Foundation

enum DreamWheelsAPI: NetworkAPIEndPoint, URLRequestable {
    case getManufacturersFor(page: Int)
    case getModelsFor(manufacturId: String, page: Int)
}

extension DreamWheelsAPI {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getManufacturersFor:
            return "/v1/car-types/manufacturer"
        case .getModelsFor:
            return "/v1/car-types/main-types"
        }
        
    }
    
    var parameters: [String : Any] {
        switch self {
        case let .getManufacturersFor(page):
            return [
                "page": page,
                "pageSize": Constants.defaultPageSize,
                "wa_key": APIConstants.waKey,
            ]
        case .getModelsFor(manufacturId: let manufacturId, page: let page):
            return [
                "manufacturer": manufacturId,
                "page": page,
                "pageSize": Constants.defaultPageSize,
                "wa_key": APIConstants.waKey,
            ]
        }
    }
    
}
