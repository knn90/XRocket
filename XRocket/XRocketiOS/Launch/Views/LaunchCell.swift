//
//  LaunchCell.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 19/4/21.
//

import UIKit
import XRocket

public final class LaunchCell: UITableViewCell {
    public let flightNumberLabel = UILabel()
    public let rocketNameLabel = UILabel()
    public let dateLabel = UILabel()
    public let successLabel = UILabel()
    func configure(launch: PresentableLaunch) {
        flightNumberLabel.text = launch.flightNumber
        rocketNameLabel.text = launch.name
        dateLabel.text = launch.launchDate
        successLabel.text = launch.status
        
    }
}

private class LaunchDateFormatter {
    static let dateFormatter = DateFormatter()
    
    static func format(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
