//
//  LaunchDetailsInfoCellController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 29/4/21.
//

import UIKit
import XRocket

public class LaunchDetailsInfoCellController: NSObject {
    private var cell: LaunchDetailsInfoCell?
    private let viewModel: LaunchDetailsViewModel
    
    public init(viewModel: LaunchDetailsViewModel) {
        self.viewModel = viewModel
    }
}

extension LaunchDetailsInfoCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchDetailsInfoCell") as! LaunchDetailsInfoCell
        cell.nameLabel.text = viewModel.name
        cell.launchDateLabel.text = viewModel.launchDateString
        cell.rocketNameLabel.text = viewModel.rocketName
        cell.statusLabel.text = viewModel.status
        cell.descriptionLabel.text = viewModel.details
        self.cell = cell
        return cell
    }
}
