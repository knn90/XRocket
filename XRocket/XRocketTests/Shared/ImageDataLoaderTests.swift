//
//  ImageDataLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import XCTest
import XRocket

class ImageDataLoader {
    public typealias Result = Swift.Result<Data, Error>
    private let client: HTTPClient
    private let request: URLRequest
    
    public init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.load(from: request) { _ in
            
        }
    }
}

class ImageDataLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [request])
    }
    
    // MARK: - Helpers
    private func makeSUT(request: URLRequest = anyURLRequest(), file: StaticString = #file, line: UInt = #line) -> (ImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ImageDataLoader(client: client, request: request)
        
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, client)
    }
}
