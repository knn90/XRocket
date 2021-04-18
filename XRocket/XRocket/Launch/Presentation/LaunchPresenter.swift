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

public final class LaunchPresenter {
    public static var title: String {
        NSLocalizedString("launch_view_title",
                          tableName: "Launch",
                          bundle: Bundle(for: LaunchPresenter.self),
                          comment: "Title for the launch view")
    }
    
    private let loadingView: LaunchLoadingView
    private let errorView: LaunchErrorView
    
    public init(loadingView: LaunchLoadingView, errorView: LaunchErrorView) {
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingLaunch() {
        errorView.display(errorMessage: nil)
        loadingView.display(isLoading: true)
    }
}
