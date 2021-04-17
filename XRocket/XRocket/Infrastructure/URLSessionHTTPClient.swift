//
//  URLSessionHTTPClient.swift
//  XRocket
//
//  Created by Khoi Nguyen on 17/4/21.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    public func load(from request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        
        task.resume()
    }
}
