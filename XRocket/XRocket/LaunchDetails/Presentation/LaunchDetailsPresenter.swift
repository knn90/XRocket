//
//  LaunchDetailsPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 24/4/21.
//

import Foundation


public protocol LaunchDetailsImageView {
    func display(_ viewModel: LaunchDetailsImageViewModel)
}

public protocol LaunchDetailsView {
    func display(_ viewModel: LaunchDetailsViewModel)
}

public struct LaunchDetailsViewModel: Equatable {
    public let name: String
    public let flightNumber: String
    public let details: String
    public let rocketName: String
    private let launchDate: Date
    private let success: Bool
    
    public var launchDateString: String {
        LaunchDateFormatter.format(from: launchDate)
    }
    
    public var status: String {
        if success {
            return LaunchDetailsString.localize(for: "launch_status_success")
        } else {
            return LaunchDetailsString.localize(for: "launch_status_failure")
        }
    }
    
    public init(name: String, flightNumber: String, success: Bool, details: String, rocketName: String, launchDate: Date) {
        self.name = name
        self.flightNumber = flightNumber
        self.success = success
        self.details = details
        self.rocketName = rocketName
        self.launchDate = launchDate
    }
}

public class LaunchDetailsPresenter {
    public static let title = LaunchDetailsString.localize(for: "launch_details_view_title")
    
    private let launchDetailsImageView: LaunchDetailsImageView
    private let launchDetailsView: LaunchDetailsView
    
    public init(launchDetailsImageView: LaunchDetailsImageView, launchDetailsView: LaunchDetailsView) {
        self.launchDetailsImageView = launchDetailsImageView
        self.launchDetailsView = launchDetailsView
    }
    
    public func display(urls: [URL]) {
        launchDetailsImageView.display(LaunchDetailsImageViewModel(urls: urls))
    }
    
    public func display(launch: Launch) {
        launchDetailsView.display(
            LaunchDetailsViewModel(
                name: launch.name,
                flightNumber: "\(launch.flightNumber)",
                success: launch.success,
                details: launch.details,
                rocketName: launch.rocket.name,
                launchDate: launch.dateUnix))
    }
}
