//
//  ImageDataLoader.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public protocol ImageDataLoaderTask {
    func cancel()
}

public class ImageDataLoader {
    public typealias Result = Swift.Result<Data, Error>
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: ImageDataLoaderTask {
        var wrapped: HTTPClientTask?
        private var completion: ((Result) -> Void)?
        
        init(_ completion: @escaping (Result) -> Void) {
            self.completion = completion
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
        
        func complete(with result: Result) {
            completion?(result)
        }
    }
    
    public func load(from request: URLRequest, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.load(from: request) { [weak self] (result) in
            guard self != nil else { return }
            task.complete(
                with: result
                    .mapError { _ in Error.connectivity }
                    .flatMap { data, response in
                        let isResponseValid = ImageDataLoader.validate(data, response: response)
                        return isResponseValid ? .success(data) : .failure(.invalidData)
                    }
            )
        }
        return task
    }
    
    private static let success = 200
    private static func validate(_ data: Data, response: HTTPURLResponse) -> Bool {
        return response.statusCode == success && !data.isEmpty
    }
}
