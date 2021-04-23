//
//  LaunchViewAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 21/4/21.
//

import UIKit
import XRocket

class LaunchViewAdapter: LaunchView {
    private weak var launchViewController: LaunchViewController?
    private let imageLoader: ImageDataLoader
    private let didSelectLaunch: (PresentableLaunch) -> Void
    
    init(launchViewController: LaunchViewController, imageLoader: ImageDataLoader, didSelectLaunch: @escaping (PresentableLaunch) -> Void) {
        self.launchViewController = launchViewController
        self.imageLoader = imageLoader
        self.didSelectLaunch = didSelectLaunch
    }
    
    func display(_ viewModel: LaunchViewModel) {
        launchViewController?.display(viewModel.presentableLaunches.map { model in
            let adapter = LaunchImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<LaunchCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = LaunchCellController(
                delegate: adapter,
                didSelectCell: { [weak self] in
                    self?.didSelectLaunch(model)
                })
            adapter.presenter = LaunchCellPresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
}
