//
//  Injected.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

@propertyWrapper
class Injected<T> {

    var wrappedValue: T

    init(resolver: Resolver = .default, tag: String? = nil) {
        guard let value = resolver.resolve(type: T.self, tag: tag) else {
            fatalError("Unable to resolve type \(String(describing: T.self))")
        }
        wrappedValue = value
    }

}
