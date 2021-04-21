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

public final class LaunchViewController: UITableViewController, UITableViewDataSourcePrefetching, LaunchView, LaunchLoadingView, LaunchErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    public var delegate: LaunchViewControllerDelegate?
    public var imageLoader: ImageDataLoader?
    private var tasks = [IndexPath: ImageDataLoaderTask]()
    private var cellControllers = [IndexPath: LaunchCellController]()
    private(set) var launches: [PresentableLaunch] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = LaunchPresenter.title
        tableView.prefetchDataSource = self
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
        return cellController(forRowAt: indexPath).cell()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> LaunchCellController {
        let model = launches[indexPath.row]
        let cellController = LaunchCellController(model: model, imageLoader: imageLoader!)
        cellControllers[indexPath] = cellController
        
        return cellController
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
