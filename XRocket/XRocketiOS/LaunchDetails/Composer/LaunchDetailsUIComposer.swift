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
    
    public static func composeWith(imageLoader: ImageDataLoader, urls: [URL]) -> LaunchDetailsViewController {
        let presentationAdapter = LaunchDetailsPresentationAdapter(urls: urls)
        let viewController = makeLaunchDetailsViewController(delegate: presentationAdapter)
        
        let presenter = LaunchDetailsPresenter(
            launchDetailsView: LaunchDetailsViewAdapter(
                viewController: viewController,
                imageLoader: imageLoader))
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

class LaunchDetailsPresentationAdapter: LaunchDetailsViewControllerDelegate {
    var presenter: LaunchDetailsPresenter?
    private let urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func requestForImageURLs() {
        presenter?.display(urls: urls)
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

class LaunchDetailsImageCellPresentationAdapter<View: LaunchImageView, Image>: LaunchDetailsImageCellControllerDelegate where View.Image == Image {
    private let url: URL
    private let imageLoader: ImageDataLoader
    var presenter: LaunchImageCellPresenter<View, Image>?
    
    init(url: URL, imageLoader: ImageDataLoader) {
        self.url = url
        self.imageLoader = imageLoader
    }
    func didRequestImage() {
        presenter?.didStartLoadingImage()
        imageLoader.load(from: URLRequest(url: url)) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImage(with: data)
            case let .failure(error):
                self?.presenter?.didFinishLoadingImage(with: error)
            }
        }
    }
       
}
