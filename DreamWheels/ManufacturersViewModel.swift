//
//  ManufacturersViewModel.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import Foundation

struct ManufacturersViewModel {
    var manufacturers: [DreamWheelModel] = []
    
    init(_ _manufacturers: [DreamWheelModel]) {
        manufacturers = _manufacturers
    }
    
    var isEmpty: Bool {
        return manufacturers.isEmpty
    }
    
    var manufacturersCount: Int {
        return manufacturers.count
    }
    
    mutating func addMoreManufacturers(_ _manufacturers: [DreamWheelModel]) {
        manufacturers += _manufacturers
    }
}
