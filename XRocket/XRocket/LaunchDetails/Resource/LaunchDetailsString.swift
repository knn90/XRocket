//
//  LaunchDetailsString.swift
//  XRocket
//
//  Created by Khoi Nguyen on 23/4/21.
//

import Foundation

import Foundation

final class LaunchDetailsString {
    static func localize(for key: String) -> String {
        NSLocalizedString(key,
        tableName: "LaunchDetails",
        bundle: Bundle(for: LaunchDetailsString.self),
        comment: "")
    }
}
