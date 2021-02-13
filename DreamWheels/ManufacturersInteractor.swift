//
//  ManufacturersInteractor.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import Foundation

final class ManufacturersIneractor: ManufacturersInteractorInput {

    let network: NetworkService
    weak var presenter: ManufacturersInteractorOutput?
    
    init(network: NetworkService) {
        self.network = network
    }
    
    //MARK: Load Manufacturers
    func loadManufacturers(for pageNum: Int) {
        let endPoint = DreamWheelsAPI.getManufacturersFor(page: pageNum)
        network.dataRequest(endPoint, objectType: ManufacturersBaseModel.self) { [weak self] (result: Result<ManufacturersBaseModel, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.presenter?.getManufacturersSuccess(response)
            case let .failure(error):
                self.presenter?.getManufacturersError(error)
            }
        }
    }
}
