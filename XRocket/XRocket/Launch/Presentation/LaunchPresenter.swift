//
//  LaunchPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public protocol LaunchLoadingView {
    func display(_ viewModel: LaunchLoadingViewModel)
}

public protocol LaunchErrorView {
    func display(_ viewModel: LaunchErrorViewModel)
}

public protocol LaunchView {
    func display(_ viewModel: LaunchViewModel)
}

public final class LaunchPresenter {
    public static var title: String {
        LaunchString.localize(for: "launch_view_title")
    }
    
    private let loadingView: LaunchLoadingView
    private let errorView: LaunchErrorView
    private let launchView: LaunchView
    private var loadErrorMessage: String {
        LaunchString.localize(for: "launch_view_connection_error")
    }
    
    public init(loadingView: LaunchLoadingView, errorView: LaunchErrorView, launchView: LaunchView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.launchView = launchView
    }
    
    public func didStartLoadingLaunch() {
        errorView.display(LaunchErrorViewModel(message: nil))
        loadingView.display(LaunchLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(LaunchErrorViewModel(message: loadErrorMessage))
        loadingView.display(LaunchLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoading(with launchPagination: LaunchPagination) {
        launchView.display(LaunchViewModel(launches: launchPagination.docs))
        loadingView.display(LaunchLoadingViewModel(isLoading: false))
    }
}
