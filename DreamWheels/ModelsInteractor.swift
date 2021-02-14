//
//  ModelsInteractor.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation

final class ModelsIneractor: ModelsInteractorInput {

    let network: NetworkService
    weak var presenter: ModelsInteractorOutput?
    
    init(network: NetworkService) {
        self.network = network
    }
    
    //MARK: Load Manufacturers
    func loadModels(for manufacturerId: String, pageNum: Int) {
        let endPoint = DreamWheelsAPI.getModelsFor(manufacturId: manufacturerId, page: pageNum)
        network.dataRequest(endPoint, objectType: DreamWheelsBaseModel.self) { [weak self] (result: Result<DreamWheelsBaseModel, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.presenter?.getModelsSuccess(response)
            case let .failure(error):
                self.presenter?.getModelsError(error)
            }
        }
    }
}
