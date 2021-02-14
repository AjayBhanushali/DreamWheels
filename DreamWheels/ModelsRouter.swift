//
//  ModelsRouter.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import UIKit

final class ModelsRouter: ModelsRouterInput {
    weak var viewController: UIViewController?
    
    func showModelsDetails(with model: DreamWheelModel, manufacturer: DreamWheelModel) {
        if let manufacturerName = manufacturer.name, let modelName = model.name {
            let message = manufacturerName + ", " + modelName
            viewController?.showAlert(title: "Nice Choice", message: message)
        }
    }
    
    
}

