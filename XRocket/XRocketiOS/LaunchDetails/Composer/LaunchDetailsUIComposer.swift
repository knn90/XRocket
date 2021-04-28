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
    
    public static func composeWith(imageLoader: ImageDataLoader, launch: Launch) -> LaunchDetailsViewController {
        let presentationAdapter = LaunchDetailsPresentationAdapter(urls: launch.links.flickr.original)
        let viewController = makeLaunchDetailsViewController(delegate: presentationAdapter)
        
        let presenter = LaunchDetailsPresenter(
            launchDetailsView: LaunchDetailsViewAdapter(
                viewController: viewController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)))
        presentationAdapter.presenter = presenter
        return viewController
    }
    
    private static func makeLaunchDetailsViewController(delegate: LaunchDetailsViewControllerDelegate) -> LaunchDetailsViewController {
        let storyboard = UIStoryboard(name: "LaunchDetails", bundle: Bundle(for: LaunchDetailsViewController.self))
        let viewController = storyboard.instantiateInitialViewController() as! LaunchDetailsViewController
        viewController.delegate = delegate
        return viewController
    }
}


class LaunchDetailsViewAdapter: LaunchDetailsView {
    private weak var viewController: LaunchDetailsViewController?
    private let imageLoader: ImageDataLoader
    
    init(viewController: LaunchDetailsViewController, imageLoader: ImageDataLoader) {
        self.viewController = viewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: LaunchDetailsViewModel) {
        viewController?.display(viewModel.urls.map { url in
            let adapter = LaunchDetailsImageCellPresentationAdapter<WeakRefVirtualProxy<LaunchDetailsImageCellController>, UIImage>(url: url, imageLoader: imageLoader)
            let view = LaunchDetailsImageCellController(delegate: adapter)
            
            adapter.presenter = LaunchImageCellPresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
}
