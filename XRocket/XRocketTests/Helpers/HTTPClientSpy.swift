//
//  HTTPClientSpy.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import Foundation
import XRocket

class HTTPClientSpy: HTTPClient {
    private(set) var requestedRequests: [URLRequest] = []
    private(set) var cancelledRequests: [URLRequest] = []
    private var completions = [(Result) -> Void]()
    
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() {
            callback()
        }
    }
    
    func load(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        requestedRequests.append(request)
        completions.append(completion)
        
        return Task { [weak self] in
            self?.cancelledRequests.append(request)
        }
    }
    
    func completeWithError(_ error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedRequests[index].url!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        completions[index](.success((data, response)))
    }
}
