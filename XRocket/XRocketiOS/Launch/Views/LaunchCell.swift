//
//  LaunchCell.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 19/4/21.
//

import UIKit

public final class LaunchCell: UITableViewCell {
    @IBOutlet private(set) public var flightNumberLabel: UILabel!
    @IBOutlet private(set) public var rocketNameLabel: UILabel!
    @IBOutlet private(set) public var dateLabel: UILabel!
    @IBOutlet private(set) public var statusLabel: UILabel!
    @IBOutlet private(set) public var imageContainer: UIView!
    @IBOutlet private(set) public var rocketImageView: UIImageView!
}
