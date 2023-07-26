//
//  InjectedTests.swift
//  
//
//  Created by  on 26/07/2023.
//

import XCTest
@testable import SwiftDI

class InjectedSpy {

    static let resolver = Resolver()

    @Injected(resolver: InjectedSpy.resolver)  var dependency1: MockDependencyProtocol
    @Injected(resolver: InjectedSpy.resolver, tag: "tag1")  var dependency2: MockDependencyProtocol

}


final class InjectedTests: XCTestCase {

    func testInjectedResolvesDependencies() {
        let id1 = UUID().uuidString
        let id2 = UUID().uuidString
        InjectedSpy.resolver.register(
            type: MockDependencyProtocol.self,
            factory: { MockDependency(id: id1) }
        )

        InjectedSpy.resolver.register(
            type: MockDependencyProtocol.self,
            tag: "tag1",
            factory: { MockDependency(id: id2) }
        )

        let sut = InjectedSpy()

        XCTAssertNotNil(sut.dependency1)
        XCTAssertEqual(sut.dependency1.id, id1)

        XCTAssertNotNil(sut.dependency2)
        XCTAssertEqual(sut.dependency2.id, id2)
    }


}
