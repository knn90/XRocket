//
//  LaunchLoaderTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import XCTest

public struct Launch: Codable, Equatable {
    public init(id: String, name: String, details: String) {
        self.id = id
        self.name = name
        self.details = details
    }
    
    let id: String
    let name: String
    let details: String
}

public struct LaunchPagination: Codable, Equatable {
    public init(docs: [Launch], totalDocs: Int, offset: Int, limit: Int, totalPages: Int, page: Int, pagingCounter: Int, hasPrevPage: Bool, hasNextPage: Bool, prevPage: Int?, nextPage: Int?) {
        self.docs = docs
        self.totalDocs = totalDocs
        self.offset = offset
        self.limit = limit
        self.totalPages = totalPages
        self.page = page
        self.pagingCounter = pagingCounter
        self.hasPrevPage = hasPrevPage
        self.hasNextPage = hasNextPage
        self.prevPage = prevPage
        self.nextPage = nextPage
    }
    
    let docs: [Launch]
    let totalDocs: Int
    let offset: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
}

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
        case invalidData
    }
    
    typealias Result = Swift.Result<LaunchPagination, LoadError>
    
    func load(completion: @escaping (Result) -> Void) {
        client.load(from: request) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let launchPagination = try decoder.decode(LaunchPagination.self, from: data)
                        completion(.success(launchPagination))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                } else {
                    completion(.failure(.badRequest))
                }
            case .failure:
                completion(.failure(.connectivity))
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
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.connectivity), when: {
            let clientError = NSError(domain: "any NSError", code: 0)
            client.completeWithError(clientError)
        })
    }
    
    func test_load_deliversErrorOn400HTTPResponse() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(.badRequest), when: {
            client.complete(withStatusCode: 400, data: anyData())
        })
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidData() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
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
    
    private func expect(_ sut: LaunchLoader, toCompleteWithResult expectedResult: LaunchLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
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

func anyURLRequest() -> URLRequest {
    URLRequest(url: URL(string: "http://any-url.com")!)
}

func anyData() -> Data {
    Data("any data".utf8)
}

