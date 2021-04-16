//
//  LaunchLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import XCTest

protocol HTTPClient {
    
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func load(from request: URLRequest, completion: @escaping (Result) -> Void)
}

class LaunchLoader {
    private let client: HTTPClient
    private let request: URLRequest
    
    init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    enum LoadError: Error {
        case connectivity
        case badRequest
    }
    
    func load(completion: @escaping (LoadError?) -> Void) {
        client.load(from: request) { result in
            switch result {
            case .success:
                completion(.badRequest)
            case .failure:
                completion(.connectivity)
            }

        }
    }
}

class LaunchLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_sendsRequestFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [request])
    }
    
    func test_loadTwice_sendsRequestFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [request, request])
    }
    
    func test_load_deliverErrorOnClientError() {
        var error: LaunchLoader.LoadError?
        let clientError = NSError(domain: "any NSError", code: 0)
        let (sut, client) = makeSUT()
        
        sut.load { error = $0 }
        client.completeWithError(clientError)
        
        XCTAssertEqual(error, .connectivity)
    }
    
    func test_load_deliverErrorOn400HTTPResponse() {
        var error: LaunchLoader.LoadError?
        let (sut, client) = makeSUT()
        
        sut.load { error = $0 }
        client.complete(withStatusCode: 400, data: anyData())
        
        XCTAssertEqual(error, .badRequest)
    }
    
    // MARK: - Helpers
    private func makeSUT(request: URLRequest = anyURLRequest(), file: StaticString = #file, line: UInt = #line) -> (LaunchLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = LaunchLoader(client: client, request: request)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URLRequest] = []
        var completions = [(Result) -> Void]()
        
        func load(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(request)
            completions.append(completion)
        }
        
        func completeWithError(_ error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index].url!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            completions[index](.success((data, response)))
        }
    }
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: URL(string: "http://any-url.com")!)
}

func anyData() -> Data {
    Data("any data".utf8)
}

