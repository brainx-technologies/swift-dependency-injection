//
//  File.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

protocol Storable {

    var identifier: UUID { get }

}

class Container<T>: Storable {

    let identifier: UUID = UUID()
    var factory: () -> T

    init(factory: @escaping () -> T) {
        self.factory = factory
    }
}
