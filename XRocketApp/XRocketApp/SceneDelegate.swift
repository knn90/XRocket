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

    var window: UIWindow?
    private var navigationController: UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let client = URLSessionHTTPClient(session: .shared)
        let url = URL(string: "https://api.spacexdata.com/v4/launches/query")!
        var launchRequest = URLRequest(url: url)
        launchRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        launchRequest.httpMethod = "POST"
        let params: [String: Any] = [
            "query": [
                "upcoming": false
            ],
            "options": [
                "sort": [
                    "date_utc": "desc"
                ]
            ]
        ]

        launchRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let launchLoader = RemoteLaunchLoader(client: client, request: launchRequest)
        let imageLoader = RemoteImageDataLoader(client: client)
        navigationController =  UINavigationController(
            rootViewController: LaunchUIComposer.composeWith(loader: launchLoader, imageLoader: imageLoader, didSelectLaunch: didSelectLaunch))
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func didSelectLaunch(_ presentableLaunch: PresentableLaunch) {
    }
}

