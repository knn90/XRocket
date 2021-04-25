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

final class LaunchCellController: NSObject, CellController, LaunchCellView {
    
    private var cell: LaunchCell?
    private let delegate: LaunchCellControllerDelegate
    private let didSelectCell: () -> Void
    
    init(delegate: LaunchCellControllerDelegate, didSelectCell: @escaping () -> Void) {
        self.delegate = delegate
        self.didSelectCell = didSelectCell
    }
    
    func display(viewModel: LaunchCellViewModel<UIImage>) {
        cell?.flightNumberLabel.text = "\(viewModel.flightNumber)"
        cell?.rocketNameLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.launchDateString
        cell?.statusLabel.text = viewModel.status
        cell?.rocketImageView.image = nil
        cell?.imageContainer.isShimmering = viewModel.isLoading
        cell?.rocketImageView.image = viewModel.image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell") as! LaunchCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        delegate.didRequestImage()
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectCell()
    }
    
    private func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
