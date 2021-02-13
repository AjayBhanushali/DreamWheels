//
//  ManufacturerProtocols.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 24/01/21.
//

import Foundation

import UIKit

//MARK: BaseViewInput
protocol BaseViewInput: AnyObject {
    func showSpinner()
    func hideSpinner()
}

extension BaseViewInput where Self: UIViewController {
    func showSpinner() {
        view.showSpinner()
    }
    
    func hideSpinner() {
        view.hideSpinner()
    }
}

//MARK: View
protocol ManufacturersViewInput: BaseViewInput {
    var presenter: ManufacturersViewOutput! { get set }
    func changeViewState(_ state: ViewState)
    func displayManufacturers(with viewModel: ManufacturersViewModel)
    func insertManufacturers(with viewModel: ManufacturersViewModel, at indexPaths: [IndexPath])
    func resetViews()
}

//MARK: Presenter
protocol ManufacturersModuleInput: AnyObject {
    var view: ManufacturersViewInput? { get set }
    var interactor: ManufacturersInteractorInput! { get set }
    var router: ManufacturersRouterInput! { get set }
}

protocol ManufacturersViewOutput: AnyObject {
    func getManufacturers()
    var isMoreDataAvailable: Bool { get }
    func didSelectManufacturer(at index: Int)
}

protocol ManufacturersInteractorOutput: AnyObject {
    func getManufacturersSuccess(_ manufacturersBase: ManufacturersBaseModel)
    func getManufacturersError(_ error: NetworkError)
}


//MARK: InteractorInput
protocol ManufacturersInteractorInput: AnyObject {
    var presenter: ManufacturersInteractorOutput? { get set }
    func loadManufacturers(for pageNum: Int)
}

//MARK: Router
protocol ManufacturersRouterInput: AnyObject {
    func showManufacturerDetails(with manufacturer: ManufacturerModel)
}
