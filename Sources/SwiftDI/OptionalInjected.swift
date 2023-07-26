//
//  OptionalInjected.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

@propertyWrapper
class OptionalInjected<T> {

    var wrappedValue: T?

    init(resolver: Resolver = .default, tag: String? = nil) {
        wrappedValue = resolver.resolve(type: T.self, tag: tag)
    }

}
