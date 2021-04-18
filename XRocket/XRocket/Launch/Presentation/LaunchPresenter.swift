//
//  LaunchPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public protocol LaunchLoadingView {
    func display(isLoading: Bool)
}

public protocol LaunchErrorView {
    func display(errorMessage: String?)
}

public protocol LaunchView {
    func display(launches: [Launch])
}

public final class LaunchPresenter {
    public static var title: String {
        NSLocalizedString("launch_view_title",
                          tableName: "Launch",
                          bundle: Bundle(for: LaunchPresenter.self),
                          comment: "Title for the launch view")
    }
    
    private let loadingView: LaunchLoadingView
    private let errorView: LaunchErrorView
    private let launchView: LaunchView
    private var loadErrorMessage: String {
        NSLocalizedString("launch_view_connection_error",
                          tableName: "Launch",
                          bundle: Bundle(for: LaunchPresenter.self),
                          comment: "Error message when loading launches")
    }
    
    public init(loadingView: LaunchLoadingView, errorView: LaunchErrorView, launchView: LaunchView) {
        self.loadingView = loadingView
        self.errorView = errorView
        self.launchView = launchView
    }
    
    public func didStartLoadingLaunch() {
        errorView.display(errorMessage: nil)
        loadingView.display(isLoading: true)
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(errorMessage: loadErrorMessage)
        loadingView.display(isLoading: false)
    }
    
    public func didFinishLoading(with launchPagination: LaunchPagination) {
        launchView.display(launches: launchPagination.docs)
        loadingView.display(isLoading: false)
    }
}
