//
//  LaunchCellViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 22/4/21.
//

import Foundation

public struct LaunchCellViewModel<Image> {
    
    public let name: String
    public let flightNumber: Int
    public let success: Bool
    public let launchDate: Date
    public let isLoading: Bool
    public let image: Image?
    
    public var status: String {
        if success {
            return LaunchString.localize(for: "launch_status_success")
        } else {
            return LaunchString.localize(for: "launch_status_failure")
        }
    }
    
    public var launchDateString: String {
        LaunchDateFormatter.format(from: launchDate)
    }
    
    public init(launch: Launch, isLoading: Bool, image: Image?) {
        self.name = launch.name
        self.flightNumber = launch.flightNumber
        self.success = launch.success
        self.launchDate = launch.dateUnix
        self.isLoading = isLoading
        self.image = image
    }
}

private class LaunchDateFormatter {
    static let dateFormatter = DateFormatter()
    
    static func format(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
