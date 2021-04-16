//
//  LaunchLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import XCTest

class LaunchLoader {
    private let client: HTTPClientSpy
    
    init(client: HTTPClientSpy) {
        self.client = client
    }
}

class HTTPClientSpy {
    var requestedURL: [URL] = []
}

class LaunchLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let client = HTTPClientSpy()
        let _ = LaunchLoader(client: client)
        
        XCTAssertTrue(client.requestedURL.isEmpty)
    }
    
    // MARK: - Helpers
}
