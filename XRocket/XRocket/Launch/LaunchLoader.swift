//
//  LaunchLoader.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public class LaunchLoader {
    public typealias Result = Swift.Result<LaunchPagination, LoadError>
    private let client: HTTPClient
    private let request: URLRequest
    
    public init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    public enum LoadError: Error {
        case connectivity
        case badRequest
        case invalidData
    }
    
    public func load(completion: @escaping (Result) -> Void) {
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
