//
//  LaunchViewController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 19/4/21.
//

import UIKit
import XRocket

public final class LaunchViewController: UITableViewController {
    
    public var loader: LaunchLoader?
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
        refreshControl?.beginRefreshing()
        loader?.load { [unowned self] result in
            self.refreshControl?.endRefreshing()
            switch result {
            case let .success(launchPagination):
                self.launches = LaunchViewModel(launches: launchPagination.docs).presentableLaunches
            case .failure: break
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LaunchCell()
        cell.configure(launch: launches[indexPath.row])
        
        return cell
    }
}
