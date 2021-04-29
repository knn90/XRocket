//
//  XCTestCase+LocalizedString.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 29/4/21.
//

import XCTest
import XRocket

extension XCTestCase {
    func launchLocalized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Launch"
        let bundle = Bundle(for: LaunchPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    func launchDetailsLocalized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "LaunchDetails"
        let bundle = Bundle(for: LaunchDetailsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
