//
//  ModelsProtocols.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation

//MARK: View
protocol ModelsViewInput: BaseViewInput {
    var presenter: ModelsViewOutput! { get set }
    func changeViewState(_ state: ViewState)
    func displayModels(with viewModel: ModelsViewModel)
    func insertModels(with viewModel: ModelsViewModel, at indexPaths: [IndexPath])
    func resetViews()
}

//MARK: Presenter
protocol ModelsModuleInput: AnyObject {
    var view: ModelsViewInput? { get set }
    var interactor: ModelsInteractorInput! { get set }
    var router: ModelsRouterInput! { get set }
}

protocol ModelsViewOutput: AnyObject {
    func getModels()
    var isMoreDataAvailable: Bool { get }
    func didSelectModel(at index: Int)
}

protocol ModelsInteractorOutput: AnyObject {
    func getModelsSuccess(_ modelsBase: DreamWheelsBaseModel)
    func getModelsError(_ error: NetworkError)
}


//MARK: InteractorInput
protocol ModelsInteractorInput: AnyObject {
    var presenter: ModelsInteractorOutput? { get set }
    func loadModels(for manufacturerId: String, pageNum: Int)
}

//MARK: Router
protocol ModelsRouterInput: AnyObject {
    func showModelsDetails(with model: DreamWheelModel, manufacturer: DreamWheelModel)
}
