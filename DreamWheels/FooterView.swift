//
//  FooterView.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 27/01/21.
//

import UIKit

final class FooterView: UICollectionReusableView, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    private func setup() {
        showSpinner()
    }
}

