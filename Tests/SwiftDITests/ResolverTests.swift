//
//  ResolverTests.swift
//  
//
//  Created by  on 26/07/2023.
//

import XCTest
@testable import SwiftDI

protocol MockDependencyProtocol {
    var id: String { get }
}

class MockDependency: MockDependencyProtocol {
    var id: String

    init(id: String) {
        self.id = id
    }
}

final class ResolverTests: XCTestCase {

    var sut: Resolver!

    override func setUp() {
        super.setUp()

        self.sut = Resolver()
    }

    func testResolvesDependency() {
        let id = UUID().uuidString
        sut.register(
            type: MockDependencyProtocol.self,
            factory: {
                MockDependency(id: id)
            }
        )

        let dependency = sut.resolve(type: MockDependencyProtocol.self)
        XCTAssertNotNil(dependency)
        XCTAssertEqual(dependency?.id, id)
    }

    func testReturnsNilOnUnresolvedDependency() {
        let dependency = sut.resolve(type: MockDependency.self)
        XCTAssertNil(dependency)
    }

    func testHandlesTaggedDependencies() {
        sut = Resolver()
        let id1 = UUID().uuidString
        let id2 = UUID().uuidString
        let id3 = UUID().uuidString

        sut.register(
            type: MockDependencyProtocol.self,
            factory: { MockDependency(id: id1) }
        )

        sut.register(
            type: MockDependencyProtocol.self,
            tag: "tag1",
            factory: { MockDependency(id: id2) }
        )

        sut.register(
            type: MockDependencyProtocol.self,
            tag: "tag2",
            factory: { MockDependency(id: id3) }
        )

        let dependency1 = sut.resolve(type: MockDependencyProtocol.self)

        XCTAssertNotNil(dependency1)
        XCTAssertEqual(dependency1?.id, id1)

        let dependency2 = sut.resolve(type: MockDependencyProtocol.self, tag: "tag1")

        XCTAssertNotNil(dependency2)
        XCTAssertEqual(dependency2?.id, id2)

        let dependency3 = sut.resolve(type: MockDependencyProtocol.self, tag: "tag2")

        XCTAssertNotNil(dependency3)
        XCTAssertEqual(dependency3?.id, id3)
    }

    func testUnregisterDependencies() {
        sut.register(
            type: MockDependencyProtocol.self,
            factory: { MockDependency(id: UUID().uuidString) }
        )

        sut.register(
            type: MockDependencyProtocol.self,
            tag: "tag",
            factory: { MockDependency(id: UUID().uuidString) }
        )

        sut.unregister(type: MockDependencyProtocol.self)

        XCTAssertNil(sut.resolve(type: MockDependencyProtocol.self))

        sut.unregister(type: MockDependencyProtocol.self, tag: "tag1")

        XCTAssertNil(sut.resolve(type: MockDependencyProtocol.self, tag: "tag1"))
    }

}
