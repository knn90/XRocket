//
//  LaunchDetailsViewController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 23/4/21.
//

import UIKit
import XRocket

public final class LaunchDetailsViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet private(set) public var collectionView: UICollectionView!
    
    var imageloader: ImageDataLoader?
    
    public var urls = [URL]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func display(_ urls: [URL]) {
        self.urls = urls
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

