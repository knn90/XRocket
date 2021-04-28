//
//  SceneDelegate.swift
//  XRocketApp
//
//  Created by Khoi Nguyen on 22/4/21.
//

import UIKit
import XRocket
import XRocketiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private lazy var client = URLSessionHTTPClient(session: .shared)
    private lazy var imageLoader = RemoteImageDataLoader(client: client)
    var window: UIWindow?
    private var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let launchLoader = RemoteLaunchLoader(client: client)
        
        navigationController =  UINavigationController(
            rootViewController: LaunchUIComposer.composeWith(loader: launchLoader, imageLoader: imageLoader, didSelectLaunch: didSelectLaunch))
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func didSelectLaunch(_ launch: Launch) {
        let launchDetailsViewController = LaunchDetailsUIComposer.composeWith(imageLoader: imageLoader, launch: launch)
        navigationController?.pushViewController(launchDetailsViewController, animated: true)
    }
}

