//
//  LaunchDetailsImageCellController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 25/4/21.
//

import Foundation
import UIKit
import XRocket

public protocol LaunchDetailsImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class LaunchDetailsImageCellController: LaunchImageView {
    
    private var cell: LaunchDetailsImageCell?
    private let delegate: LaunchDetailsImageCellControllerDelegate
    
    public init(delegate: LaunchDetailsImageCellControllerDelegate) {
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
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    func releaseCellForReuse() {
        cell = nil
    }
}
