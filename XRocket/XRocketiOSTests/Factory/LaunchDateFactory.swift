//
//  LaunchDateFactory.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 29/4/21.
//

import Foundation

class LaunchDateFactory {
    static func date1() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1614846240), "2021-03-04")
    }
    
    static func date2() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1612419540), "2021-02-04")
    }
    
    static func date3() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1611500400), "2021-01-24")
    }
    
    static func date4() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1610072100), "2021-01-08")
    }
}
