//
//  HTTPClientSpy.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//

import Foundation
import XRocket

class HTTPClientSpy: HTTPClient {
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
