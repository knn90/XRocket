//
//  File.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func load(from request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
