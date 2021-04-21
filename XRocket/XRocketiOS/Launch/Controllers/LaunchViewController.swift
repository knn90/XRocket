//
//  LaunchViewController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 19/4/21.
//

import UIKit
import XRocket

public protocol LaunchViewControllerDelegate {
    func didRequestForLaunches()
}

public final class LaunchViewController: UITableViewController, LaunchView, LaunchLoadingView, LaunchErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    public var delegate: LaunchViewControllerDelegate?
    public var imageLoader: ImageDataLoader?
    private var tasks = [IndexPath: ImageDataLoaderTask]()
    
    private(set) var launches: [PresentableLaunch] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = LaunchPresenter.title
        loadLaunches()
    }
    
    @IBAction private func loadLaunches() {
        delegate?.didRequestForLaunches()
    }
    
    public func display(_ viewModel: LaunchViewModel) {
        self.launches = viewModel.presentableLaunches
    }
    
    public func display(_ viewModel: LaunchLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    public func display(_ viewModel: LaunchErrorViewModel) {
        errorView?.message = viewModel.message
    }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LaunchCell()
        let model = launches[indexPath.row]
        cell.configure(launch: model)
        cell.rocketImageView.image = nil
        if let url = model.imageURL {
            cell.imageContainer.isShimmering = true
            let request = URLRequest(url: url)
            tasks[indexPath] = imageLoader?.load(from: request) { [weak cell] result in
                let data = try? result.get()
                cell?.rocketImageView.image = data.map(UIImage.init) ?? nil
                cell?.imageContainer.isShimmering = false
            }
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
