//
//  Reusable.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/12/20.
//

import Foundation
import UIKit

//MARK: Reusable

/// Protocol meant to return self as a string
protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
