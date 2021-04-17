//
//  URLSessionHTTPClientTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import XCTest
import XRocket

class URLSessionHTTPClientTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_load_performsRequestFromURL() {
        let url = URL(string: "http://a-specific-url.com")!
        let request = anyURLRequest(url: url, httpMethod: "POST")
        
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "POST")
            exp.fulfill()
        }
        
        makeSUT().load(from: request) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_failsOnRequestError() {
        let sut = makeSUT()
        let requestError = anyNSError()
        
        let exp = expectation(description: "Wait for load completion")
        var receivedError: Error?
        URLProtocolStub.stub(data: nil, response: nil, error: requestError)
        
        sut.load(from: anyURLRequest()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_load_failsOnAllInvalidCases() {
        XCTAssertNotNil(resultError(whenLoadWith: (data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultError(whenLoadWith: (data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultError(whenLoadWith: (data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultError(whenLoadWith: (data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultError(whenLoadWith: (data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(whenLoadWith: (data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(whenLoadWith: (data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(whenLoadWith: (data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultError(whenLoadWith: (data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_load_deliversSuccessOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValue(whenLoadWith: (data: data, response: response, error: nil))
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        
        trackForMemoryLeak(sut, file: file, line: line)
        
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
            let requestObserver: ((URLRequest) -> Void)?
        }
        
        private static var _stub: Stub?
        private static var stub: Stub? {
            get { return queue.sync { _stub } }
            set { queue.sync { _stub = newValue } }
        }
        
        private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error, requestObserver: nil)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
        }
        
        static func removeStub() {
            stub = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
            
            stub.requestObserver?(request)
        }
        
        override func stopLoading() {}
    }
    
    private func resultValue(whenLoadWith values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let receivedResult = result(whenLoadWith: values)
        switch receivedResult {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(receivedResult) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultError(whenLoadWith values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let receivedResult = result(whenLoadWith: values)
        switch receivedResult {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(receivedResult) instead", file: file, line: line)
            return nil
        }
    }
    
    private func result(whenLoadWith values: (data: Data?, response: URLResponse?, error: Error?)) -> HTTPClient.Result {
        let sut = makeSUT()
        URLProtocolStub.stub(data: values.data, response: values.response, error: values.error)
        var receivedResult: HTTPClient.Result!
        let exp = expectation(description: "Wait for load completion")
        sut.load(from: anyURLRequest()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResult
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
