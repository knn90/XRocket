//
//  LaunchCellViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 22/4/21.
//

import Foundation

public struct LaunchCellViewModel<Image> {
    public let name: String
    public let flightNumber: String
    public let status: String
    public let launchDate: String
    public let isLoading: Bool
    public let image: Image?
}
