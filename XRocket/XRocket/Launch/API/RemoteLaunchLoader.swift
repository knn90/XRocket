//
//  RemoteLaunchLoader.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public protocol LaunchLoader {
    typealias Result = Swift.Result<LaunchPagination, Error>
    
    func load(completion: @escaping (LaunchLoader.Result) -> Void)
}

public class RemoteLaunchLoader: LaunchLoader {
    
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
    
    public func load(completion: @escaping (LaunchLoader.Result) -> Void) {
        client.load(from: request) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteLaunchLoader.map(from: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static let success = 200
    private static func map(from data: Data, response: HTTPURLResponse) -> LaunchLoader.Result {
        if response.statusCode == success {
            do {
                let launchPagination = try JSONDecoder().decode(LaunchPagination.self, from: data)
                return .success(launchPagination)
            } catch {
                return .failure(Error.invalidData)
            }
        } else {
            return .failure(Error.badRequest)
        }
    }
}
