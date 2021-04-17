//
//  URLSessionHTTPClientTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import XCTest
import XRocket

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    func load(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if data?.count == 0, response == nil, error == nil {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        
        task.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
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
    
    func test_load_failsOnAllNilValues() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        var receivedError: Error?
        
        URLProtocolStub.stub(data: nil, response: nil, error: nil)
        
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
}