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
    private let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func requestForImageURLs() {
        presenter?.display(urls: urls)
    }
}
