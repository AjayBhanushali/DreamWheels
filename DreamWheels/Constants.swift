//
//  Constants.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/10/20.
//  
//

import Foundation
import UIKit

/// Use strings of the app from this location
enum Strings {
    static let cancel = "Cancel"
    static let ok = "OK"
    static let retry = "Retry"
    static let error = "Error"
    static let close = "close"
    
    static let appTitle = "DreamWheels"
    static let manufacturers = "Manufacturers"
}

/// App fonts size should be used from here
enum APP_FONT_SIZE: Float {
    case TITLE      = 20
    case DEFAULT    = 17
    case SUB_TITLE  = 14
    case SMALL      = 12
    case NANO       = 10
    case HEADER1    = 32
    case HEADER2    = 26
    case HEADER3    = 22
}

/// App font styles should be used from here
enum APP_FONT_STYLE: String {
    case LIGHT      = "HelveticaNeue-Light"
    case REGULAR    = "HelveticaNeue"
    case MEDIUM     = "HelveticaNeue-Medium"
    case BOLD       = "HelveticaNeue-Bold"
}

/// App images name should be used from here
enum APP_IMAGES: String {
    case Recent = "recent"
}

/// App Colors shoud be used from here
enum APP_COLOR: String {
    case THEME = "3ca5dd"
    case SUB_THEME = "70c295"
}

/// App constants which are UI specific
enum Constants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let defaultSpacing: CGFloat = 1
    static let defaultPadding: CGFloat = 8
    static let numberOfColumns: CGFloat = 1
    static let defaultRadius: CGFloat = 10
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
    static let defaultPageSize: Int = 15
    static let defaultIconSize: CGFloat = 24
}

/// breaking down a screen in its common/mostly used states
public enum ViewState: Equatable {
    case loading
    case content
    case error(String)
    case none
}

//NetworkAPI Constants
enum APIConstants {
    static let baseURL = "http://api-aws-eu-qa-1.auto1-test.com"
    static let waKey = "coding-puzzle-client-449cc9d"
}
