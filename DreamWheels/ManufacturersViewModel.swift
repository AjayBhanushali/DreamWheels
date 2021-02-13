//
//  ManufacturersViewModel.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import Foundation

struct ManufacturersViewModel {
    var manufacturers: [ManufacturerModel] = []
    
    init(_ _manufacturers: [ManufacturerModel]) {
        manufacturers = _manufacturers
    }
    
    var isEmpty: Bool {
        return manufacturers.isEmpty
    }
    
    var manufacturersCount: Int {
        return manufacturers.count
    }
    
    mutating func addMoreManufacturers(_ _manufacturers: [ManufacturerModel]) {
        manufacturers += _manufacturers
    }
}
