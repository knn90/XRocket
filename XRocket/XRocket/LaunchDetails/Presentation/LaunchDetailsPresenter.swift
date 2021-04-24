//
//  LaunchDetailsPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 24/4/21.
//

import Foundation


public protocol LaunchDetailsView {
    func display(_ viewModel: LaunchDetailsViewModel)
}

public class LaunchDetailsPresenter {
    public static let title = LaunchDetailsString.localize(for: "launch_details_view_title")
    
    private let launchDetailsView: LaunchDetailsView
    
    public init(launchDetailsView: LaunchDetailsView) {
        self.launchDetailsView = launchDetailsView
    }
    
    public func display(urls: [URL]) {
        launchDetailsView.display(LaunchDetailsViewModel(urls: urls))
    }
}
