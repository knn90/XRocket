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
    func configure(launch: Launch) {
        flightNumberLabel.text = "\(launch.flightNumber)"
        rocketNameLabel.text = launch.name
        dateLabel.text = LaunchDateFormatter.format(from: launch.dateUTC)
        if launch.success {
            successLabel.text = "Success"
        } else {
            successLabel.text = "Failure"
        }
    }
}

private class LaunchDateFormatter {
    static let dateFormatter = DateFormatter()
    
    static func format(from date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
