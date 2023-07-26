import XCTest
@testable import SwiftDI


class OptionalInjectedSpy {

    static var resolver = Resolver()

    @OptionalInjected(resolver: OptionalInjectedSpy.resolver)  var dependency1: MockDependencyProtocol?
}

final class OptionalInjectedTests: XCTestCase {

    func testOptionalInjectedResolvesDependency() {
        let id = UUID().uuidString
        OptionalInjectedSpy.resolver = Resolver()
        OptionalInjectedSpy.resolver.register(
            type: MockDependencyProtocol.self,
            factory: { MockDependency(id: id) }
        )

        let sut = OptionalInjectedSpy()

        XCTAssertNotNil(sut.dependency1)
        XCTAssertEqual(sut.dependency1?.id, id)

    }

    func testOptionalInjectedReturnsNilOnUnresolvedDependency() {
        OptionalInjectedSpy.resolver = Resolver()
        let sut = OptionalInjectedSpy()
        XCTAssertNil(sut.dependency1)
    }
}
