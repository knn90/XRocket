//
//  LaunchViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public struct LaunchViewModel {
    private let launches: [Launch]
    public var presentableLaunches: [PresentableLaunch] {
        return launches.map {
            let statusKey = $0.success ? "launch_status_success" : "launch_status_failure"
            return PresentableLaunch(
                id: $0.id,
                name: $0.name,
                flightNumber: "\($0.flightNumber)",
                status: LaunchString.localize(for: statusKey),
                launchDate: LaunchDateFormatter.format(from: $0.dateUTC))
        }
    }
    public init(launches: [Launch]) {
        self.launches = launches
    }
}

private class LaunchDateFormatter {
    static let dateFormatter = DateFormatter()
    
    static func format(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

