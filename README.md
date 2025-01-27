# SwiftDI

This is a small Swift package that provides a simple Dependency Injection (DI) mechanism to manage and resolve dependencies in your iOS or macOS applications. Dependency injection is a design pattern that allows you to decouple the creation and management of objects from their usage, making your code more modular, testable, and maintainable.
  
## Installation

You can install SwiftDI using Swift Package Manager. Add the following line to your dependencies in Package.swift

```
.package(url: "https://github.com/brainx-technologies/swift-dependency-injection.git", from: "1.0.0"),
```
## Usage
### Registering Dependencies
To register a dependency, you need to specify its type and a factory closure that produces instances of that type. The `Resolver` class is responsible for registering and resolving dependencies.

```swift
protocol UserRepository {
    // protocol requirements
}

class DefaultUserRepository: UserRepository {
    // class implementation
}

Resolver.default.register(
    type: UserRepository.self,
    factory: { DefaultUserRepository() }
)
```

If you want to register multiple dependencies of the same type, you can either use tags or scopes.

#### Using Tags
Tags allow you to differentiate between multiple implementations of the same type:

```swift 
Resolver.default.register(
    type: UserRepository.self,
    tag: "tag1",
    factory: { DefaultUserRepository() }
)
Resolver.default.register(
    type: UserRepository.self,
    tag: "tag2",
    factory: { DefaultUserRepository() }
)
```

#### Using Scopes
Scopes provide a more powerful way to manage different instances of dependencies based on context. This is particularly useful when you need different instances in different parts of your application:

```swift
// Create scopes
let mainScope = ScopedResolver.default.createScope(with: "main")
let featureScope = ScopedResolver.default.createScope(with: "feature")

// Register dependencies in different scopes
ScopedResolver.default.register(
    type: UserRepository.self,
    in: mainScope,
    factory: { DefaultUserRepository() }
)

ScopedResolver.default.register(
    type: UserRepository.self,
    in: featureScope,
    factory: { FeatureUserRepository() }
)

// Execute code within a scope
mainScope.createWithin {
    // Dependencies resolved here will use mainScope
    let repository = ScopedResolver.default.resolve(type: UserRepository.self)
}
```

### Injecting Dependencies
To inject a registered dependency into your classes, you can use the provided property wrappers: `@Injected`, `@OptionalInjected`, and `@ScopeInjected`

#### @Injected
Use `@Injected` to inject a required dependency. If the dependency cannot be resolved, it will trigger a fatal error.
```swift 
class ProfileViewModel {
    @Injected var repository: UserRepository
}
```
Use `tag` parameter for injecting tagged dependencies:
```swift
class ProfileViewModel {
    @Injected(tag: "tag1") var repository: UserRepository
}
```

#### @ScopeInjected
Use `@ScopeInjected` to inject a dependency from the current scope. The dependency must be resolved within a scope:
```swift
class ProfileViewModel {
    @ScopeInjected var repository: UserRepository
}

// Usage
mainScope.createWithin {
    let viewModel = ProfileViewModel() // repository will be resolved from mainScope
}
```

#### @OptionalInjected
Use `@OptionalInjected` to inject an optional dependency. If the dependency cannot be resolved, the wrapped value will be `nil`
```swift 
class ProfileViewModel {
    @OptionalInjected var repository: UserRepository
}
```

## Contributing
If you encounter any issues, have ideas for improvements, or want to contribute to this project, please feel free to create a pull request or raise an issue on GitHub.
