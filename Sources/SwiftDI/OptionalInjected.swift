//
//  OptionalInjected.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

@propertyWrapper
public class OptionalInjected<T> {

    public var wrappedValue: T?

    public init(resolver: Resolver = .default, tag: String? = nil) {
        wrappedValue = resolver.resolve(type: T.self, tag: tag)
    }

}
