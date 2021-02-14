//
//  ModelsPresenter.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import Foundation

class ModelsPresenter: ModelsModuleInput {
    weak var view: ModelsViewInput?
    var interactor: ModelsInteractorInput!
    var router: ModelsRouterInput!
    
    var modelsViewModel: ModelsViewModel!
    
    var pageNum = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
    init(manufacturer: DreamWheelModel) {
        modelsViewModel = ModelsViewModel(manufacturer)
    }
    
    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNum < totalPages
    }
}

extension ModelsPresenter: ModelsViewOutput {
    
    func getModels() {
        guard isMoreDataAvailable else {
            view?.changeViewState(.content)
            return
        }
        view?.changeViewState(.loading)
        if let manufacturerId = modelsViewModel.manufacturer.id  {
            interactor.loadModels(for: manufacturerId, pageNum: pageNum)
        }
        
        pageNum += 1
    }
    
    func didSelectModel(at index: Int) {
        if let model = modelsViewModel.models?[index] {
            router.showModelsDetails(with: model,
                                     manufacturer: modelsViewModel.manufacturer)
        }
    }
}

extension ModelsPresenter: ModelsInteractorOutput {
    func getModelsSuccess(_ manufacturersBase: DreamWheelsBaseModel) {
        guard let models = manufacturersBase.wkda?.list else { return }
        
        if pageNum == Constants.defaultPageNum+1 {
            totalCount = models.count
            modelsViewModel.models = models
            if let _totalPages = manufacturersBase.totalPageCount {
                totalPages = _totalPages
            }

            DispatchQueue.main.async { [unowned self] in
                self.view?.displayModels(with: modelsViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMoreModels(with: models)
        }
    }
    
    fileprivate func insertMoreModels(with models: [DreamWheelModel]) {
        let previousCount = totalCount
        totalCount += models.count
        modelsViewModel.addMoreModels(models)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertModels(with: modelsViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }
    
    func getModelsError(_ error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.description))
        }
    }
}
