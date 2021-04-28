//
//  LaunchLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import XCTest
import XRocket

class LaunchLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedRequests.isEmpty)
    }
    
    func test_load_sendsRequestFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT()
        
        sut.load(request: request) { _ in }
        
        XCTAssertEqual(client.requestedRequests, [request])
    }
    
    func test_loadTwice_sendsRequestFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url.com")!)
        let (sut, client) = makeSUT()
        
        sut.load(request: request) { _ in }
        sut.load(request: request) { _ in }
        
        XCTAssertEqual(client.requestedRequests, [request, request])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(RemoteLaunchLoader.Error.connectivity), when: {
            let clientError = NSError(domain: "any NSError", code: 0)
            client.completeWithError(clientError)
        })
    }
    
    func test_load_deliversErrorOn400HTTPResponse() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(RemoteLaunchLoader.Error.badRequest), when: {
            client.complete(withStatusCode: 400, data: anyData())
        })
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidData() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(RemoteLaunchLoader.Error.invalidData), when: {
            let invalidData = Data("Invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidData)
        })
    }
    
    func test_load_deliversLaunchesOn200HTTPResponseWithValidData() {
        let (sut, client) = makeSUT()
        let expectedResponse = LaunchPaginationFactory.single()
            
        expect(sut, toCompleteWithResult: .success(expectedResponse), when: {
            let data = expectedResponse.toJSONData()
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteLaunchLoader? = RemoteLaunchLoader(client: client)
        
        var receivedResult: RemoteLaunchLoader.Result?
        sut?.load(request: anyURLRequest()) { receivedResult = $0 }
        
        sut = nil
        client.complete(withStatusCode: 200, data: Data())
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RemoteLaunchLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLaunchLoader(client: client)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteLaunchLoader, toCompleteWithResult expectedResult: RemoteLaunchLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load(request: anyURLRequest()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.success(expectedResponse), .success(receivedResponse)):
                XCTAssertEqual(expectedResponse, receivedResponse, "Expected to get success with \(expectedResponse), got \(receivedResponse) instead", file: file, line: line)
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError as? RemoteLaunchLoader.Error, receivedError as? RemoteLaunchLoader.Error, "Expected to get failure with \(expectedError), got \(receivedError) instead", file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1.0)
    }
}


