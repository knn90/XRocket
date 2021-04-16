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
    
    enum LoadError: Error {
        case connectivity
    }
    
    func load(completion: @escaping (LoadError?) -> Void) {
        client.load(from: request) { error in
            if error != nil {
                completion(.connectivity)
            }
        }
    }
}

class HTTPClientSpy {
    var requestedURL: [URLRequest] = []
    var completions = [(Error?) -> Void]()
    
    func load(from request: URLRequest, completion: @escaping (Error?) -> Void) {
        requestedURL.append(request)
        completions.append(completion)
    }
    
    func completeWithError(_ error: Error, at index: Int = 0) {
        completions[index](error)
    }
}

class LaunchLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURL.isEmpty)
    }
    
    func test_load_sendsRequestFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURL, [request])
    }
    
    func test_loadTwice_sendsRequestFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURL, [request, request])
    }
    
    func test_load_deliverErrorOnClientError() {
        var error: LaunchLoader.LoadError?
        let clientError = NSError(domain: "any NSError", code: 0)
        let (sut, client) = makeSUT()
        
        sut.load { error = $0 }
        client.completeWithError(clientError)
        
        XCTAssertEqual(error, .connectivity)
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

