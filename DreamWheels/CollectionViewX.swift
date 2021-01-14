//
//  CollectionViewX.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 13/10/20.
//
//

import Foundation
import UIKit

extension UICollectionView {
    /// To Register cells using
    /// - Parameter cellClass: Cell type
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) where Cell: Reusable {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// To make dequeue more readable and simple
    /// - Parameter indexPath: IndexPath of Cell for row at
    /// - Returns: the cell object
    final func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell where Cell: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Failed to dequeue a cell with identifier \(Cell.reuseIdentifier) matching type \(Cell.self).")
        }
        return cell
    }
    
    //MARK: UICollectionReusableView
    /// To register reusable views
    /// - Parameters:
    ///   - supplementaryViewType: Type of the view
    ///   - elementKind: elementKind description
    final func register<T: UICollectionReusableView>(_ supplementaryViewType: T.Type, ofKind elementKind: String)
    where T: Reusable {
        self.register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.reuseIdentifier
        )
    }
    
    /// To deque supplementory views
    /// - Parameters:
    ///   - elementKind: elementKind description
    ///   - indexPath: indexPath description
    ///   - viewType: viewType description
    /// - Returns: description
    final func dequeueReusableSupplementaryView<T: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: T.Type = T.self) -> T
    where T: Reusable {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        )
        guard let typedView = view as? T else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier) "
                    + "matching type \(viewType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the supplementary view beforehand"
            )
        }
        return typedView
    }
}
