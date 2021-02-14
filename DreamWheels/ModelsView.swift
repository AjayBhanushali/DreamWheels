//
//  ModelsView.swift
//  DreamWheels
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import UIKit

class ModelsView: UIView {
    
    // MARK: View Properties
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .appBlack()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(with: .MEDIUM, of: .SUB_TITLE)
        return titleLabel
    }()
    
    // MARK: Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    // MARK: Private Custom Methods
    private func prepareView() {
        addSubview(titleLabel)
        titleLabel.pinEdgesEquallyToSuperview(atrributes: [.leading, .trailing, .bottom, .top], constant: Constants.defaultPadding)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(with: .BOLD, of: .TITLE)
    }
    
    func prepareTitle(with title: String) {
        titleLabel.text = title
    }
}
