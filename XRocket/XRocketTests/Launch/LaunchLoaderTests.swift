//
//  LaunchLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import XCTest

class LaunchLoader {
    private let client: HTTPClientSpy
    private let request: URLRequest
    
    init(client: HTTPClientSpy, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    func load() {
        client.load(from: request)
    }
}

class HTTPClientSpy {
    var requestedURL: [URLRequest] = []
    
    func load(from request: URLRequest) {
        requestedURL.append(request)
    }
}

class LaunchLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURL.isEmpty)
    }
    
    func test_load_sendRequestFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, [request])
    }
    
    func test_loadTwice_sendRequestFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        
        let (sut, client) = makeSUT(request: request)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURL, [request, request])
    }
    
    // MARK: - Helpers
    private func makeSUT(request: URLRequest = anyURLRequest(), file: StaticString = #file, line: UInt = #line) -> (LaunchLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = LaunchLoader(client: client, request: request)
        
        return (sut, client)
    }
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: URL(string: "http://any-url.com")!)
}

