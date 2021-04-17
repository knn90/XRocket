//
//  ImageDataLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import XCTest
import XRocket

class ImageDataLoader {
    private let client: HTTPClient
    private let request: URLRequest
    
    public init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
}

class ImageDataLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let request = anyURLRequest()
        let client = HTTPClientSpy()
        let _ = ImageDataLoader(client: client, request: request)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
