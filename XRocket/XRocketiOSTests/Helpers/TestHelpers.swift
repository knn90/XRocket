//
//  TestHelpers.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 19/4/21.
//

import Foundation

func anyURLRequest(
    url: URL = anyURL(),
    httpMethod: String = "GET")
-> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    
    return request
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

func anyNSError() -> NSError {
    NSError(domain: "any", code: 0)
}
