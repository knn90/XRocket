//
//  ImageDataLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import XCTest
import XRocket

class ImageDataLoaderTests: XCTestCase {
    func test_init_doesNotSendRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedRequests.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        let (sut, client) = makeSUT()
        
        _ = sut.load(from: request) { _ in }
        
        XCTAssertEqual(client.requestedRequests, [request])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        let (sut, client) = makeSUT()
        
        _ = sut.load(from: request) { _ in }
        _ = sut.load(from: request) { _ in }
        
        XCTAssertEqual(client.requestedRequests, [request, request])
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
    
    func test_load_deliversSuccessWithDataOn200HTTPReponseWithData() {
        let (sut, client) = makeSUT()
        let nonEmptyData = Data("non-empty data".utf8)
        expect(sut, toCompleteWithResult: .success(nonEmptyData), when: {
            client.complete(withStatusCode: 200, data: nonEmptyData)
        })
    }
    
    func test_cancel_cancelsClientURLRequest() {
        let (sut, client) = makeSUT()
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        
        let task = sut.load(from: request) { _  in }
        XCTAssertEqual(client.cancelledRequests, [])
        task.cancel()
        XCTAssertEqual(client.cancelledRequests, [request])
    }
    
    func test_cancel_doesNotDeliverResultAfterCancellingTask() {
        let (sut, client) = makeSUT()
        let request = URLRequest(url: URL(string: "http://a-specific-url")!)
        
        var receivedResults = [ImageDataLoader.Result]()
        let task = sut.load(from: request) { receivedResults.append($0) }
        task.cancel()
        
        client.complete(withStatusCode: 400, data: Data())
        client.complete(withStatusCode: 200, data: Data("non-empty-data".utf8))
        client.completeWithError(anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_load_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: ImageDataLoader? = ImageDataLoader(client: client)
        
        var receivedResult: ImageDataLoader.Result?
        _ = sut?.load(from: anyURLRequest()) { receivedResult = $0 }
        
        sut = nil
        client.completeWithError(anyNSError())
        
        XCTAssertNil(receivedResult)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = ImageDataLoader(client: client)
        
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, client)
    }
    
    private func expect(_ sut: ImageDataLoader, toCompleteWithResult expectedResult: ImageDataLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        _ = sut.load(from: anyURLRequest()) { receivedResult in
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
