//
//  XCTestCase+TestHelpers.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 17/4/21.
//
import Foundation

func anyURLRequest() -> URLRequest {
    URLRequest(url: URL(string: "http://any-url.com")!)
}

func anyData() -> Data {
    Data("any data".utf8)
}


