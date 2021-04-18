//
//  XCTestCase+MemoryLeak.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 18/4/21.
//
import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
