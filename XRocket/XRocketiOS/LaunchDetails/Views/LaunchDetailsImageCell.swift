//
//  LaunchDetailsImageCell.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 23/4/21.
//

import UIKit

public final class LaunchDetailsImageCell: UICollectionViewCell {
    @IBOutlet private(set) public var imageView: UIImageView!
    @IBOutlet private(set) public var imageContainer: UIView!
    @IBOutlet private(set) public var retryButton: UIButton!
    
    var onRetry: (() -> Void)?
    
    @IBAction private func retry() {
        onRetry?()
    }
}
