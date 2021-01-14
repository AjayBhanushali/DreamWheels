//
//  UIImageX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 11/10/20.
//  
//

import UIKit

extension UIImage {
    /// To streamline init process
    /// - Parameter name: APP_IMAGES
    convenience init(with name: APP_IMAGES) {
        self.init(named: name.rawValue)!
    }
    
    /// To create an image from the color
    /// - Parameters:
    ///   - color: Color for the image
    ///   - size: size of the image(mostly same as imageview)
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

