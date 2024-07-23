//
//  File.swift
//  
//
//  Created by brainx on 23/07/2024.
//

import Foundation

@propertyWrapper
public class LazyInjected<T> {

    private var resolver: Resolver
    private var tag: String?
    private var cache: T?

    public init(resolver: Resolver = .default, tag: String? = nil) {
        self.resolver = resolver
        self.tag = tag
    }

    public var wrappedValue: T {
        if let cache {
            return cache
        }

        guard let value = resolver.resolve(type: T.self, tag: tag) else {
            fatalError("Unable to resolve type \(String(describing: T.self))")
        }
        cache = value
        return value
    }

}
