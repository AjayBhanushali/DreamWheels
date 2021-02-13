//
//  ManufacturersVC.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import UIKit

class ManufacturersVC: UIViewController {
    
    var presenter: ManufacturersViewOutput!
    var viewState: ViewState = .none
    var manufacturersViewModel: ManufacturersViewModel?
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing = Constants.defaultSpacing
        let itemWidth: CGFloat = (UIScreen.main.bounds.width - (Constants.numberOfColumns - spacing) - 2) / Constants.numberOfColumns
        let itemHeight: CGFloat = 40
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .appBackground()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: ViewController Lifecycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .appBackground()
        navigationItem.title = Strings.appTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.getManufacturers()
    }
    
    private func setupViews() {
        configureCollectionView()
    }
    
    //MARK: ConfigureCollectionView
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperview()
        collectionView.registerCell(GenericCollectionViewCell<ManufacturersView>.self)
        collectionView.register(FooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
    }
}

extension ManufacturersVC: ManufacturersViewInput {
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if manufacturersViewModel == nil {
                showSpinner()
            }
        case .content:
            hideSpinner()
            collectionView.collectionViewLayout.invalidateLayout()
        case .error(let message):
            hideSpinner()
            showAlert(title: Strings.error, message: message, retryAction: { [unowned self] in
                self.presenter.getManufacturers()
            })
        default:
            break
        }
    }
    
    func displayManufacturers(with viewModel: ManufacturersViewModel) {
        manufacturersViewModel = viewModel
        collectionView.reloadData()
    }
    
    func insertManufacturers(with viewModel: ManufacturersViewModel, at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.manufacturersViewModel = viewModel
            self.collectionView.insertItems(at: indexPaths)
        })
    }
    
    func resetViews() {
        manufacturersViewModel = nil
        collectionView.reloadData()
    }
    
    
}

extension ManufacturersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = manufacturersViewModel, !viewModel.isEmpty else {
            return 0
        }
        return viewModel.manufacturersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GenericCollectionViewCell<ManufacturersView>
        
        guard let viewModel = manufacturersViewModel else {
            return cell
        }
         
        guard cell.cellView != nil else {
            let cardView = ManufacturersView(frame: .zero)
            cell.cellView = cardView
            
            if let manufacturersName = viewModel.manufacturers[indexPath.item].name {
                cell.cellView?.prepareTitle(with: manufacturersName)
            }
            return cell
        }
        
        if let manufacturersName = viewModel.manufacturers[indexPath.item].name {
            cell.cellView?.prepareTitle(with: manufacturersName)
        }
        return cell
    }
    
    
}

extension ManufacturersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: UICollectionViewFooter
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewState == .loading && manufacturersViewModel != nil {
            return CGSize(width: Constants.screenWidth, height: 50)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as FooterView
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
