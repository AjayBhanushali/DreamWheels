//
//  ModelsBuilder.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation

protocol ModelsModuleBuilderProtocol {
    func buildModule(with manufacturer: DreamWheelModel) -> ModelsVC
}

final class ModelsModuleBuilder: ModelsModuleBuilderProtocol {
    
    func buildModule(with manufacturer: DreamWheelModel) -> ModelsVC {
        
        let modelsVC = ModelsVC()
        let presenter = ModelsPresenter(manufacturer: manufacturer)
        let network = NetworkAPI()
        let interactor = ModelsIneractor(network: network)
        let router = ModelsRouter()
        
        presenter.view = modelsVC
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        modelsVC.presenter = presenter
        router.viewController = modelsVC
        
        return modelsVC
    }
}
