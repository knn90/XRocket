//
//  LaunchDetailsPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 24/4/21.
//

import Foundation


public protocol LaunchDetailsImageView {
    func display(_ viewModel: LaunchDetailsImageViewModel)
}

public protocol LaunchDetailsView {
    func display(_ viewModel: LaunchDetailsViewModel)
}

public struct LaunchDetailsViewModel {

}

public class LaunchDetailsPresenter {
    public static let title = LaunchDetailsString.localize(for: "launch_details_view_title")
    
    private let launchDetailsView: LaunchDetailsImageView
    
    public init(launchDetailsView: LaunchDetailsImageView) {
        self.launchDetailsView = launchDetailsView
    }
    
    public func display(urls: [URL]) {
        launchDetailsView.display(LaunchDetailsImageViewModel(urls: urls))
    }
}
