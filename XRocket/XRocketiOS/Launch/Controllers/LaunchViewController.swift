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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = LaunchPresenter.title
        loadLaunches()
    }
    
    @IBAction private func loadLaunches() {
        refreshControl?.beginRefreshing()
        loader?.load { [unowned self] _ in
            self.refreshControl?.endRefreshing()
        }
    }
}
