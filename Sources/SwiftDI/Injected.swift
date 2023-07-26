//
//  Injected.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

@propertyWrapper
public class Injected<T> {

    public var wrappedValue: T

    public init(resolver: Resolver = .default, tag: String? = nil) {
        guard let value = resolver.resolve(type: T.self, tag: tag) else {
            fatalError("Unable to resolve type \(String(describing: T.self))")
        }
        wrappedValue = value
    }

}
