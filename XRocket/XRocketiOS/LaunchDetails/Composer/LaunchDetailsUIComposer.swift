//
//  LaunchDetailsUIComposer.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 23/4/21.
//

import Foundation
import XRocket
import UIKit

public final class LaunchDetailsUIComposer {
    private init() {}
    
    public static func composeWith(imageLoader: ImageDataLoader) -> LaunchDetailsViewController {
        let viewController = makeLaunchDetailsViewController()
        viewController.imageloader = imageLoader
        return viewController
    }
    
    private static func makeLaunchDetailsViewController() -> LaunchDetailsViewController {
        let storyboard = UIStoryboard(name: "LaunchDetails", bundle: Bundle(for: LaunchDetailsViewController.self))
        let viewController = storyboard.instantiateInitialViewController() as! LaunchDetailsViewController
        
        return viewController
    }
}
