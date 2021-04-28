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
    private let didSelectLaunch: (Launch) -> Void
    
    init(launchViewController: LaunchViewController, imageLoader: ImageDataLoader, didSelectLaunch: @escaping (Launch) -> Void) {
        self.launchViewController = launchViewController
        self.imageLoader = imageLoader
        self.didSelectLaunch = didSelectLaunch
    }
    
    func display(_ viewModel: LaunchViewModel) {
        let newItem = viewModel.launches.map(makeController)
        if viewModel.pageNumber == 1 {
            launchViewController?.set(newItem)
        } else {
            launchViewController?.append(newItem)
        }
    }
    
    private func makeController(_ model: Launch) -> CellController {
        let adapter = LaunchImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<LaunchCellController>, UIImage>(model: model, imageLoader: imageLoader)
        let view = LaunchCellController(
            delegate: adapter,
            didSelectCell: { [weak self] in
                self?.didSelectLaunch(model)
            })
        adapter.presenter = LaunchCellPresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
        
        return CellController(id: model, view)
    }
}
