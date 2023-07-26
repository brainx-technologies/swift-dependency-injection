//
//  Resolver.swift
//  
//
//  Created by  on 26/07/2023.
//

import Foundation

public class Resolver {

    private struct Key: Hashable {
        var identifier: ObjectIdentifier
        var tag: String?
    }

    public static let `default` = Resolver()

    private var registeries = [Key: Storable]()

    /// Register a dependency
    public func register<T>(type: T.Type, tag: String? = nil, factory: @escaping () -> T) {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )
        let container = Container(factory: factory)
        registeries[key] = container
    }

    /// Resolves a dependency
    public func resolve<T>(type: T.Type, tag: String? = nil) -> T? {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )

        guard let container = registeries[key] as? Container<T> else {
            return nil
        }

        return container.factory()
    }

    /// Unregister a depenendency
    public func unregister<T>(type: T.Type, tag: String? = nil) {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )

        registeries.removeValue(forKey: key)
    }

}
