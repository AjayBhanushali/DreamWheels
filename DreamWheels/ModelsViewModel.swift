//
//  ModelsViewModel.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation

struct ModelsViewModel {
    var manufacturer: DreamWheelModel!
    var models: [DreamWheelModel]?
    
    init(_ _manufacturer: DreamWheelModel) {
        manufacturer = _manufacturer
    }
    
    var isEmpty: Bool {
        return models == nil
    }
    
    var modelsCount: Int {
        return models?.count ?? 0
    }
    
    mutating func addMoreModels(_ _models: [DreamWheelModel]) {
        guard models != nil else {
            models = _models
            return
        }
        models! += _models
    }
}
