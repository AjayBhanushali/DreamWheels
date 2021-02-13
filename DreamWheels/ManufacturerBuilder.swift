//
//  ManufacturerBuilder.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 12/02/21.
//

import Foundation

protocol ManufacturersModuleBuilderProtocol: AnyObject {
    func buildModule() -> ManufacturersVC
}


final class ManufacturersModuleBuilder: ManufacturersModuleBuilderProtocol {
    
    func buildModule() -> ManufacturersVC {
        let vc = ManufacturersVC()
        let presenter = ManufacturersPresenter()
        let network = NetworkAPI()
        let interactor = ManufacturersIneractor(network: network)
        let router = ManufacturersRouter()
        
        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        vc.presenter = presenter
        router.viewController = vc
        
        return vc
    }
}

