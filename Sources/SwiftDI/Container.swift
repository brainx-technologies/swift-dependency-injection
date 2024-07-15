//
//  Container.swift
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
    var singleInstance: Bool

    init(factory: @escaping () -> T, singleInstance: Bool) {
        self.factory = factory
        self.singleInstance = singleInstance
    }
}
