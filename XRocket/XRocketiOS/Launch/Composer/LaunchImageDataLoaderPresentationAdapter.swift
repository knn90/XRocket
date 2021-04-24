//
//  LaunchImageDataLoaderPresentationAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 22/4/21.
//

import Foundation
import XRocket

class LaunchImageDataLoaderPresentationAdapter<View: LaunchCellView, Image>: LaunchCellControllerDelegate where View.Image == Image {
    private let model: Launch
    private let imageLoader: ImageDataLoader
    private var task: ImageDataLoaderTask?
    var presenter: LaunchCellPresenter<View, Image>?
 
    init(model: Launch, imageLoader: ImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImage(for: model)
        let model = self.model
        let url = model.links.patch.small
        
        task = imageLoader.load(from: URLRequest(url: url)) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImage(with: data, for: model)
            case let .failure(error):
                self?.presenter?.didFinishLoadingImage(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
