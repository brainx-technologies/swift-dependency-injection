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
    private var cache = [Key: Storable]()

    public init() {
    }

    public func register<T>(
        type: T.Type,
        singleton: Bool = false,
        factory: @escaping () -> T
    ) {
        register(type: type, tag: nil, singleton: singleton, factory: factory)
    }

    @available(*, deprecated, message: "Use ScopedResolver for context-based resolution instead of tag")
    public func register<T>(
        type: T.Type,
        tag: String? = nil,
        singleton: Bool = false,
        factory: @escaping () -> T
    ) {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )
        let container = Container(factory: factory, singleInstance: singleton)
        registeries[key] = container
    }

    /// Resolves a dependency
    public func resolve<T>(type: T.Type) -> T?  {
        resolve(type: type, tag: nil)
    }

    @available(*, deprecated, message: "Use ScopedResolver for context-based resolution instead of tag")
    public func resolve<T>(type: T.Type, tag: String? = nil) -> T? {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )

        guard let container = registeries[key] as? Container<T> else {
            return nil
        }

        guard container.singleInstance else {
            return container.factory()
        }

        if let cachedContainer = cache[key] as? SingletonContainer<T> {
            return cachedContainer.instance
        }

        let instance = container.factory()
        cache[key] = SingletonContainer(instance: instance)

        return instance
    }

    /// Unregister a depenendency
    public func unregister<T>(type: T.Type) {
        unregister(type: type, tag: nil)
    }


    @available(*, deprecated, message: "Use ScopedResolver for context-based resolution instead of tag")
    public func unregister<T>(type: T.Type, tag: String? = nil) {
        let key = Key(
            identifier: ObjectIdentifier(type),
            tag: tag
        )

        registeries.removeValue(forKey: key)
    }

}
