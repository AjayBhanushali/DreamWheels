//
//  NavigationControllerX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 16/12/20.
//

import UIKit

extension UINavigationController {
    
    func themeNavigationBar() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = UIColor.appBlack()
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.fontColor()
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.largeTitleTextAttributes = titleTextAttributes
    }
    
}
