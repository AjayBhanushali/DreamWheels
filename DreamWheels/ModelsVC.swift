//
//  ModelsVC.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import UIKit

class ModelsVC: UIViewController {
    
    var presenter: ModelsViewOutput!
    var viewState: ViewState = .none
    var modelsViewModel: ModelsViewModel?
    
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
        presenter.getModels()
    }
    
    private func setupViews() {
        configureCollectionView()
    }
    
    //MARK: ConfigureCollectionView
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperview()
        collectionView.registerCell(GenericCollectionViewCell<ModelsView>.self)
        collectionView.register(FooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
    }
}

extension ModelsVC: ModelsViewInput {
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if modelsViewModel == nil {
                showSpinner()
            }
        case .content:
            hideSpinner()
            collectionView.collectionViewLayout.invalidateLayout()
        case .error(let message):
            hideSpinner()
            showAlert(title: Strings.error, message: message, retryAction: { [unowned self] in
                self.presenter.getModels()
            })
        default:
            break
        }
    }
    
    func displayModels(with viewModel: ModelsViewModel) {
        modelsViewModel = viewModel
        collectionView.reloadData()
    }
    
    func insertModels(with viewModel: ModelsViewModel, at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.modelsViewModel = viewModel
            self.collectionView.insertItems(at: indexPaths)
        })
    }
    
    func resetViews() {
        modelsViewModel = nil
        collectionView.reloadData()
    }
    
    
}

extension ModelsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = modelsViewModel, !viewModel.isEmpty else {
            return 0
        }
        return viewModel.modelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GenericCollectionViewCell<ModelsView>
        
        guard let viewModel = modelsViewModel else {
            return cell
        }
         
        guard cell.cellView != nil else {
            let cardView = ModelsView(frame: .zero)
            cell.cellView = cardView
            
            if let modelsName = viewModel.models?[indexPath.item].name {
                cell.cellView?.prepareTitle(with: modelsName)
            }
            return cell
        }
        
        if let modelsName = viewModel.models?[indexPath.item].name {
            cell.cellView?.prepareTitle(with: modelsName)
        }
        return cell
    }
    
    
}

extension ModelsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let viewModel = modelsViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.modelsCount - 1) else {
            return
        }
        presenter.getModels()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectModel(at: indexPath.item)
    }
    
    //MARK: UICollectionViewFooter
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewState == .loading && modelsViewModel != nil {
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

