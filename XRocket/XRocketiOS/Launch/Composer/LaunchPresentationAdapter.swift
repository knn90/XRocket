//
//  LaunchPresentationAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import Foundation
import XRocket

class LaunchPresentationAdapter: LaunchViewControllerDelegate {
    private let loader: LaunchLoader
    var presenter: LaunchPresenter?
    
    init(loader: LaunchLoader) {
        self.loader = loader
    }
    
    func didRequestForLaunches() {
        presenter?.didStartLoadingLaunch()
        loader.load { [weak self] result in
            switch result {
            case let .success(launchPagination):
                self?.presenter?.didFinishLoading(with: launchPagination)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
