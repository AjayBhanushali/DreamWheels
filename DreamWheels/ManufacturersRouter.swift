//
//  ManufacturersRouter.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 12/02/21.
//

import UIKit

final class ManufacturersRouter: ManufacturersRouterInput {
    weak var viewController: UIViewController?
    
    func showModels(with manufacturer: DreamWheelModel) {
        let vc = ModelsModuleBuilder().buildModule(with: manufacturer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

