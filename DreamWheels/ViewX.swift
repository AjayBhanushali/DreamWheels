//
//  ViewX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 11/10/20.
//  
//

import UIKit

extension UIView {
    /// To show loader
    func showSpinner() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = .appBlack()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    /// To hide loader
    func hideSpinner() {
        guard let spinner = self.subviews.last as? UIActivityIndicatorView else { return }
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    /// To give corner radius
    /// - Parameter radius: radius
    func giveCorner(radius: CGFloat) {
        layer.cornerRadius = radius
    }
}
