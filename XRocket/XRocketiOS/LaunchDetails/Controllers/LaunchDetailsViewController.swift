//
//  LaunchDetailsViewController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 23/4/21.
//

import UIKit
import XRocket

public protocol LaunchDetailsViewControllerDelegate {
    func requestForImageURLs()
}

public final class LaunchDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    @IBOutlet private(set) public var collectionView: UICollectionView!
    var delegate: LaunchDetailsViewControllerDelegate?
    private var cellControllers = [LaunchDetailsImageCellController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.requestForImageURLs()
    }
    
    public func display(_ cellControllers: [LaunchDetailsImageCellController]) {
        self.cellControllers = cellControllers
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellControllers[indexPath.item].view(in: collectionView, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.item].preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellControllers[indexPath.item].cancelLoad()
        }
    }
}


public protocol LaunchDetailsImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class LaunchDetailsImageCellController: LaunchImageView {
    
    private var cell: LaunchDetailsImageCell?
    private let delegate: LaunchDetailsImageCellControllerDelegate
    
    init(delegate: LaunchDetailsImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in collectionView: UICollectionView, at indexPath: IndexPath) -> LaunchDetailsImageCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchDetailsImageCell", for: indexPath) as! LaunchDetailsImageCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    public func display(viewModel: LaunchImageViewModel<UIImage>) {
        cell?.imageContainer.isShimmering = viewModel.isLoading
        cell?.imageView.image = viewModel.image
        cell?.retryButton.isHidden = !viewModel.shouldRetry
        cell?.onRetry = delegate.didRequestImage
        
        cell?.retryButton.addTarget(cell, action: #selector(cell?.retry), for: .touchUpInside)
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
}

