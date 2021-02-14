//
//  ManufacturersPresenter.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import Foundation

class ManufacturersPresenter: ManufacturersModuleInput {
    weak var view: ManufacturersViewInput?
    var interactor: ManufacturersInteractorInput!
    var router: ManufacturersRouterInput!
    
    var manufacturersViewModel: ManufacturersViewModel!
    
    var pageNum = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNum < totalPages
    }
}

extension ManufacturersPresenter: ManufacturersViewOutput {
    func getManufacturers() {
        guard isMoreDataAvailable else {
            view?.changeViewState(.content)
            return
        }
        view?.changeViewState(.loading)
        interactor.loadManufacturers(for: pageNum)
        pageNum += 1
    }
    
    func didSelectManufacturer(at index: Int) {
        let manufacturer = manufacturersViewModel.manufacturers[index]
        router.showManufacturerDetails(with: manufacturer)
    }
}

extension ManufacturersPresenter: ManufacturersInteractorOutput {
    func getManufacturersSuccess(_ manufacturersBase: ManufacturersBaseModel) {
        guard let manufacturers = manufacturersBase.wkda?.manufacturers else { return }
        
        if pageNum == Constants.defaultPageNum+1 {
            manufacturersViewModel = ManufacturersViewModel(manufacturers)
            totalCount = manufacturers.count
            
            if let _totalPages = manufacturersBase.totalPageCount {
                totalPages = _totalPages
            }

            DispatchQueue.main.async { [unowned self] in
                self.view?.displayManufacturers(with: manufacturersViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMoreManufacturers(with: manufacturers)
        }
    }
    
    fileprivate func insertMoreManufacturers(with manufacturers: [ManufacturerModel]) {
        let previousCount = totalCount
        totalCount += manufacturers.count
        manufacturersViewModel.addMoreManufacturers(manufacturers)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertManufacturers(with: manufacturersViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }
    
    func getManufacturersError(_ error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.description))
        }
    }
}
