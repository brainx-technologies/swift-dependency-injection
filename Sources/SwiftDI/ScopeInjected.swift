//
//  File.swift
//  
//
//  Created by brainx on 18/09/2024.
//

import Foundation

@propertyWrapper
public class ScopeInjected<T> {

    public let wrappedValue: T

    public init() {
        guard let value = ScopedResolver.default.resolve(type: T.self) else {
            fatalError("Unable to resolve type \(T.self)")
        }

        wrappedValue = value
    }
}
