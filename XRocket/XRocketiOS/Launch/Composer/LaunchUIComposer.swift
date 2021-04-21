//
//  LaunchUIComposer.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import UIKit
import XRocket

public final class LaunchUIComposer {
    
    public static func composeWith(loader: LaunchLoader, imageLoader: ImageDataLoader) -> LaunchViewController {
        let presentationAdapter = LaunchPresentationAdapter(loader: loader)
        
        let launchController = makeLaunchViewController(delegate: presentationAdapter)
        launchController.imageLoader = imageLoader
        
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
