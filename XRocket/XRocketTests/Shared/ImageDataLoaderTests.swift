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
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.load(from: request) { (result) in
            switch result {
            case let .success((data, response)):
                if response.statusCode != 200 || data.isEmpty {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
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
    
    func test_loadTwice_requestDataFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        let (sut, client) = makeSUT(request: request)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [request, request])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity), when: {
            let clientError = NSError(domain: "any NSError", code: 0)
            client.completeWithError(clientError)
        })
    }
    
    func test_load_deliversInvalidErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sampleCode = [199, 201, 330, 486, 500]
        sampleCode.enumerated().forEach { index,code in
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_load_deliversInvalidErrorOn200HTTPResponseWithEmptyData() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
            let emptyData = Data()
            client.complete(withStatusCode: 200, data: emptyData)
        })
    }
    
    // MARK: - Helpers
    private func makeSUT(request: URLRequest = anyURLRequest(), file: StaticString = #file, line: UInt = #line) -> (ImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ImageDataLoader(client: client, request: request)
        
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: ImageDataLoader, toCompleteWithResult expectedResult: ImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedResponse), .success(receivedResponse)):
                XCTAssertEqual(expectedResponse, receivedResponse, "Expected to get success with \(expectedResponse), got \(receivedResponse) instead", file: file, line: line)
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError, receivedError, "Expected to get failure with \(expectedError), got \(receivedError) instead", file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }

}
