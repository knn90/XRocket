//
//  LaunchLoader.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public class LaunchLoader {
    public typealias Result = Swift.Result<LaunchPagination, Error>
    private let client: HTTPClient
    private let request: URLRequest
    
    public init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case badRequest
        case invalidData
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.load(from: request) { result in
            switch result {
            case let .success((data, response)):
                completion(LaunchLoader.map(from: data, response: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private static let success = 200
    private static func map(from data: Data, response: HTTPURLResponse) -> Result {
        if response.statusCode == success {
            do {
                let launchPagination = try JSONDecoder().decode(LaunchPagination.self, from: data)
                return .success(launchPagination)
            } catch {
                return .failure(.invalidData)
            }
        } else {
            return .failure(.badRequest)
        }
    }
}
