//
//  LaunchCellController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 21/4/21.
//

import UIKit
import XRocket

public protocol LaunchCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class LaunchCellController: LaunchCellView {
    private var cell: LaunchCell?
    private let delegate: LaunchCellControllerDelegate
    
    init(delegate: LaunchCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func display(viewModel: LaunchCellViewModel<UIImage>) {
        cell?.flightNumberLabel.text = viewModel.flightNumber
        cell?.rocketNameLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.launchDate
        cell?.statusLabel.text = viewModel.status
        cell?.rocketImageView.image = nil
        cell?.imageContainer.isShimmering = viewModel.isLoading
        cell?.rocketImageView.image = viewModel.image
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell") as! LaunchCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
