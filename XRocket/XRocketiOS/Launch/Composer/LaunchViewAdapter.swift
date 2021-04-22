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
    
    init(launchViewController: LaunchViewController, imageLoader: ImageDataLoader) {
        self.launchViewController = launchViewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: LaunchViewModel) {
        launchViewController?.display(viewModel.presentableLaunches.map { model in
            let adapter = LaunchImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<LaunchCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = LaunchCellController(delegate: adapter)
            adapter.presenter = LaunchCellPresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
}
