//
//  LaunchPresentationAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import Foundation
import XRocket

class LaunchPresentationAdapter: LaunchViewControllerDelegate, LoadMoreControllerDelegate {
    private let loader: LaunchLoader
    var presenter: LaunchPresenter?
    
    init(loader: LaunchLoader) {
        self.loader = loader
    }
    
    func load(page: Int) {
        loader.load(request: LaunchEndpoint.makeRequest(page: page)) { [weak self] result in
            switch result {
            case let .success(launchPagination):
                self?.presenter?.didFinishLoading(with: launchPagination)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
    
    func didRequestForLaunches() {
        presenter?.didStartLoadingLaunch()
        load(page: 1)
    }
    
    func didRequestLoadMore(page: Int) {
        presenter?.didStartLoadMoreLaunch(page: page)
        load(page: page)
    }
}

class LaunchEndpoint {
    static func makeRequest(page: Int) -> URLRequest {
        let url = URL(string: "https://api.spacexdata.com/v4/launches/query")!
        var launchRequest = URLRequest(url: url)
        launchRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        launchRequest.httpMethod = "POST"
        let params: [String: Any] = [
            "query": [
                "upcoming": false
            ],
            "options": [
                "sort": [
                    "date_utc": "desc"
                ],
                "page": page
            ]
        ]

        launchRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        return launchRequest
    }
}
