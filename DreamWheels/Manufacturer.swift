//
//  Manufacturer.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 24/01/21.
//

import Foundation

struct DreamWheelsBaseModel: Decodable {
    let page : Int?
    let pageSize : Int?
    let totalPageCount : Int?
    let wkda: DreamWheelsModel?
    
    // Define DynamicCodingKeys type needed for creating
    // decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {
        
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        case pageSize = "pageSize"
        case totalPageCount = "totalPageCount"
        case wkda = "wkda"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pageSize = try values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalPageCount = try values.decodeIfPresent(Int.self, forKey: .totalPageCount)
        wkda = try values.decodeIfPresent(DreamWheelsModel.self, forKey: .wkda)
    }
    
    
}

struct DreamWheelsModel: Decodable {
    let list: [DreamWheelModel]?
    
    // Define DynamicCodingKeys type needed for creating
    // decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {
        
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        // 1
        // Create a decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [DreamWheelModel]()
        
        // 2
        // Loop through each key (student ID) in container
        for key in container.allKeys {
            // Decode Student using key & keep decoded Student object in tempArray
            let value = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            let decodedObject = DreamWheelModel(id: key.stringValue, name: value)
            tempArray.append(decodedObject)
        }
        
        // 3
        // Finish decoding all Student objects. Thus assign tempArray to array.
        list = tempArray
    }
}

struct DreamWheelModel: Decodable {
    var id: String?
    var name: String?
}

