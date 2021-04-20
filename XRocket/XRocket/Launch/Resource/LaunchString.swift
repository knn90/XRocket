//
//  LaunchString.swift
//  XRocket
//
//  Created by Khoi Nguyen on 20/4/21.
//

import Foundation

final class LaunchString {
    static func localize(for key: String) -> String {
        NSLocalizedString(key,
        tableName: "Launch",
        bundle: Bundle(for: LaunchPresenter.self),
        comment: "")
    }
}
