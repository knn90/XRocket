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

public protocol LaunchLoadMoreView {
    func display(_ viewModel: LaunchLoadMoreViewModel)
}

public final class LaunchPresenter {
    public static var title: String {
        LaunchString.localize(for: "launch_view_title")
    }
    
    private let loadingView: LaunchLoadingView
    private let errorView: LaunchErrorView
    private let launchView: LaunchView
    private let loadMoreView: LaunchLoadMoreView
    
    private var loadErrorMessage: String {
        LaunchString.localize(for: "launch_view_connection_error")
    }
    
    public init(loadingView: LaunchLoadingView, errorView: LaunchErrorView, launchView: LaunchView, loadMoreView: LaunchLoadMoreView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.launchView = launchView
        self.loadMoreView = loadMoreView
    }
    
    public func didStartLoadingLaunch() {
        errorView.display(LaunchErrorViewModel(message: nil))
        loadingView.display(LaunchLoadingViewModel(isLoading: true))
        loadMoreView.display(LaunchLoadMoreViewModel(isLoading: true, hasNextPage: false, pageNumber: 0))
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(LaunchErrorViewModel(message: loadErrorMessage))
        loadingView.display(LaunchLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoading(with launchPagination: LaunchPagination) {
        launchView.display(LaunchViewModel(launches: launchPagination.docs))
        loadingView.display(LaunchLoadingViewModel(isLoading: false))
        loadMoreView.display(LaunchLoadMoreViewModel(isLoading: false, hasNextPage: launchPagination.hasNextPage, pageNumber: launchPagination.page))
    }
}
