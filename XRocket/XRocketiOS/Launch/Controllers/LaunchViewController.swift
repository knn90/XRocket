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

public final class LaunchViewController: UITableViewController, UITableViewDataSourcePrefetching, LaunchLoadingView, LaunchErrorView {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    public var delegate: LaunchViewControllerDelegate?
    var tableModel: [LaunchCellController] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        loadLaunches()
    }
    
    @IBAction private func loadLaunches() {
        delegate?.didRequestForLaunches()
    }
    
    func display(_ cellControllers: [LaunchCellController]) {
        tableModel = cellControllers
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
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> LaunchCellController {
        return tableModel[indexPath.row]
        
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
