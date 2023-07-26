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

If you want to register multiple dependencies of the same type, you can use a tag to differentiate between them

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
### Injecting Dependencies
To inject a registered dependency into your classes, you can use the provided property wrappers: `@Injected` and `@OptionalInjected`

#### @Injected
Use `@Injected` to inject a required dependency. If the dependency cannot be resolved, it will trigger a fatal error.
```swift 
class ProfileViewModel {
    @Injected var repository: UserRepository
}
```
Use `tag` parameter for injecting tagged dependencies
```swift
class ProfileViewModel {
    @Injected(tag: "tag1") var repository: UserRepository
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
