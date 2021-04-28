//
//  LaunchViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public struct LaunchViewModel {
    public let launches: [Launch]
    public let pageNumber: Int
    public init(launches: [Launch], pageNumber: Int) {
        self.launches = launches
        self.pageNumber = pageNumber
    }
}

