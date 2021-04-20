//
//  LaunchUIComposer.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import UIKit
import XRocket

public final class LaunchUIComposer {
    
    public static func composeWith(loader: LaunchLoader) -> LaunchViewController {
        let presentationAdapter = LaunchPresentationAdapter(loader: loader)
        
        let launchController = makeLaunchViewController(delegate: presentationAdapter)
        
        let presenter = LaunchPresenter(
            loadingView: WeakRefVirtualProxy(launchController),
            errorView: WeakRefVirtualProxy(launchController),
            launchView: WeakRefVirtualProxy(launchController))
        presentationAdapter.presenter = presenter
        
        return launchController
    }
    
    private static func makeLaunchViewController(delegate: LaunchViewControllerDelegate) -> LaunchViewController {
        let storyboard = UIStoryboard(name: "Launch", bundle: Bundle(for: LaunchViewController.self))
        let viewController = storyboard.instantiateInitialViewController() as! LaunchViewController
        viewController.delegate = delegate
        
        return viewController
    }
}

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

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: LaunchView where T: LaunchView {
    func display(_ viewModel: LaunchViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchErrorView where T: LaunchErrorView {
    func display(_ viewModel: LaunchErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchLoadingView where T: LaunchLoadingView {
    func display(_ viewModel: LaunchLoadingViewModel) {
        object?.display(viewModel)
    }
}
