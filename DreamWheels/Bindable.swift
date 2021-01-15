//
//  Bindable.swift
//  DreamWheels
//
//  Created by Ajay on 15/01/21.
//

import Foundation

final class Bindable<T> {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listener?(self.value)
            }
            
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
