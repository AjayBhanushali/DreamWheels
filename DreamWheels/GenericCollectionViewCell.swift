//
//  GenericCollectionViewCell.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import UIKit

/// to use views as collection cell
class GenericCollectionViewCell<View: UIView>: UICollectionViewCell {
    
    // MARK: View Properties
    var cellView: View? {
        didSet {
            guard cellView != nil else { return }
            setUpViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private custom methods
    private func setUpViews() {
        guard let cellView = cellView else { return }
        addSubview(cellView)
        cellView.pinEdgesToSuperview()
    }
}

