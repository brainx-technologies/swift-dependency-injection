//
//  File.swift
//  
//
//  Created by brainx on 18/09/2024.
//

import Foundation

public class ScopedResolver {

    public class Scope: Hashable {

        public var identifier: String
        internal var stack: ScopeStack

        internal init(identifier: String, stack: ScopeStack) {
            self.identifier = identifier
            self.stack = stack
        }

        static public func == (lhs: ScopedResolver.Scope, rhs: ScopedResolver.Scope) -> Bool {
            lhs.identifier == rhs.identifier
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        public func createWithin<T>(_ execute: () -> T) -> T {
            stack.push(self)
            defer {
                stack.pop()
            }

            return execute()
        }

    }

    struct Key: Hashable {
        var objectIdentifier: ObjectIdentifier
        var scope: Scope
    }

    class ScopeStack {

        private var stack = [Scope]()

        var currentScope: Scope? {
            stack.last
        }

        func push(_ scope: Scope) {
            stack.append(scope)
        }

        func pop() {
            if !stack.isEmpty {
                stack.removeLast()
            }
        }
    }

    static public let `default` = ScopedResolver()

    private var registeries = [Key: Storable]()
    private var cache = [Key: Storable]()
    private var scopeStack = ScopeStack()


    public func register<T>(
        type: T.Type,
        singleton: Bool = false,
        in scope: Scope,
        factory: @escaping () -> T
    ) {
        let container = Container(factory: factory, singleInstance: singleton)
        let key = Key(objectIdentifier: ObjectIdentifier(type), scope: scope)
        registeries[key] = container
    }

    public func resolve<T>(type: T.Type) -> T? {
        guard let scope = scopeStack.currentScope else {
            return nil
        }

        return resolve(type: type, from: scope)
    }

    public func createScope(with identifier: String = UUID().uuidString) -> Scope {
        Scope(identifier: identifier, stack: scopeStack)
    }

    internal func resolve<T>(type: T.Type, from scope: Scope) -> T? {
        let key = Key(objectIdentifier: ObjectIdentifier(type), scope: scope)

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

}
