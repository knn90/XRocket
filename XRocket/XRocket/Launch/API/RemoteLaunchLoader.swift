//
//  RemoteLaunchLoader.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public protocol LaunchLoader {
    typealias Result = Swift.Result<LaunchPagination, Error>
    
    func load(request: URLRequest, completion: @escaping (LaunchLoader.Result) -> Void)
}

public class RemoteLaunchLoader: LaunchLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case badRequest
        case invalidData
    }
    
    public func load(request: URLRequest, completion: @escaping (LaunchLoader.Result) -> Void) {
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
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                let launchPagination = try jsonDecoder.decode(LaunchPagination.self, from: data)
                return .success(launchPagination)
            } catch {
                return .failure(Error.invalidData)
            }
        } else {
            return .failure(Error.badRequest)
        }
    }
}
