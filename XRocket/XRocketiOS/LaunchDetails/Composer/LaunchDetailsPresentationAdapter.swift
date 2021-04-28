//
//  LaunchDetailsPresentationAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 25/4/21.
//

import Foundation
import XRocket

class LaunchDetailsPresentationAdapter: LaunchDetailsViewControllerDelegate {
    var presenter: LaunchDetailsPresenter?
    private let launch: Launch
    
    init(launch: Launch) {
        self.launch = launch
    }
    
    func requestForImageURLs() {
        presenter?.display(urls: launch.links.flickr.original)
    }
    
    func populateLaunchDetails() {
        
    }
}
