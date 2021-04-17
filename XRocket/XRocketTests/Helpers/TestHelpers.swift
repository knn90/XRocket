//
//  XCTestCase+TestHelpers.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//
import Foundation

func anyURLRequest(
    url: URL = URL(string: "http://any-url.com")!,
    httpMethod: String = "GET")
-> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    
    return request
}

func anyData() -> Data {
    Data("any data".utf8)
}


