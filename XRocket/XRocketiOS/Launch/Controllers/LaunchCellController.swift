//
//  LaunchCellController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 21/4/21.
//

import UIKit
import XRocket

final class LaunchCellController {
    private var task: ImageDataLoaderTask?
    private let model: PresentableLaunch
    private let imageLoader: ImageDataLoader
    
    init(model: PresentableLaunch, imageLoader: ImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func cell() -> UITableViewCell {
        let cell = LaunchCell()
        cell.configure(launch: model)
        cell.rocketImageView.image = nil
        if let url = model.imageURL {
            cell.imageContainer.isShimmering = true
            let request = URLRequest(url: url)
            task = imageLoader.load(from: request) { [weak cell] result in
                let data = try? result.get()
                cell?.rocketImageView.image = data.map(UIImage.init) ?? nil
                cell?.imageContainer.isShimmering = false
            }
        }
        return cell
    }
    
    func preload() {
        if let url = model.imageURL {
            let request = URLRequest(url: url)
            task = imageLoader.load(from: request) { _ in }
        }
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
