//
//  LaunchUIComposer.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import UIKit
import XRocket

public final class LaunchUIComposer {
    private init() {}
    
    public static func composeWith(loader: LaunchLoader, imageLoader: ImageDataLoader, didSelectLaunch: @escaping (PresentableLaunch) -> Void) -> LaunchViewController {
        let presentationAdapter = LaunchPresentationAdapter(loader: MainQueueDispatchDecorator(decoratee: loader))
        
        let launchController = makeLaunchViewController(delegate: presentationAdapter)
        
        let presenter = LaunchPresenter(
            loadingView: WeakRefVirtualProxy(launchController),
            errorView: WeakRefVirtualProxy(launchController),
            launchView: LaunchViewAdapter(
                launchViewController: launchController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader),
                didSelectLaunch: didSelectLaunch))
        presentationAdapter.presenter = presenter
        
        return launchController
    }
    
    private static func makeLaunchViewController(delegate: LaunchViewControllerDelegate) -> LaunchViewController {
        let storyboard = UIStoryboard(name: "Launch", bundle: Bundle(for: LaunchViewController.self))
        let viewController = storyboard.instantiateInitialViewController() as! LaunchViewController
        viewController.title = LaunchPresenter.title
        viewController.delegate = delegate
        
        return viewController
    }
}
