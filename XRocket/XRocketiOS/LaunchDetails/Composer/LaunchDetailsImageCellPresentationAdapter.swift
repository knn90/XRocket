//
//  LaunchDetailsImageCellPresentationAdapter.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 25/4/21.
//

import UIKit
import XRocket

class LaunchDetailsImageCellPresentationAdapter<View: LaunchImageView, Image>: LaunchDetailsImageCellControllerDelegate where View.Image == Image {
    private let url: URL
    private let imageLoader: ImageDataLoader
    var presenter: LaunchImageCellPresenter<View, Image>?
    var task: ImageDataLoaderTask?
    
    init(url: URL, imageLoader: ImageDataLoader) {
        self.url = url
        self.imageLoader = imageLoader
    }
    func didRequestImage() {
        presenter?.didStartLoadingImage()
        task = imageLoader.load(from: URLRequest(url: url)) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImage(with: data)
            case let .failure(error):
                self?.presenter?.didFinishLoadingImage(with: error)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
