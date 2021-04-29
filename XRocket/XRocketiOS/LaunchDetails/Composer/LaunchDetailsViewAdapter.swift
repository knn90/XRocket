//
//  LaunchDetailsViewAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 29/4/21.
//

import UIKit
import XRocket

class LaunchDetailsViewAdapter: LaunchDetailsImageView, LaunchDetailsView {
    private weak var viewController: LaunchDetailsViewController?
    private let imageLoader: ImageDataLoader
    
    init(viewController: LaunchDetailsViewController, imageLoader: ImageDataLoader) {
        self.viewController = viewController
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: LaunchDetailsImageViewModel) {
        viewController?.display(viewModel.urls.map { url in
            let adapter = LaunchDetailsImageCellPresentationAdapter<WeakRefVirtualProxy<LaunchDetailsImageCellController>, UIImage>(url: url, imageLoader: imageLoader)
            let view = LaunchDetailsImageCellController(delegate: adapter)
            
            adapter.presenter = LaunchImageCellPresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
    
    func display(_ viewModel: LaunchDetailsViewModel) {
        viewController?.populate([LaunchDetailsInfoCellController(viewModel: viewModel)])
    }
}
