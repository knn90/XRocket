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

public final class LaunchDetailsViewController: UIViewController {
    
    @IBOutlet private(set) public var collectionView: UICollectionView!
    var delegate: LaunchDetailsViewControllerDelegate?
    private var cellControllers = [LaunchDetailsImageCellController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private struct Constants {
        static let collectionHeight: CGFloat = 300
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createCollectionViewLayout()
        delegate?.requestForImageURLs()
    }
    
    public func display(_ cellControllers: [LaunchDetailsImageCellController]) {
        self.cellControllers = cellControllers
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.collectionHeight))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension LaunchDetailsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellControllers[indexPath.item].view(in: collectionView, at: indexPath)
    }
}

extension LaunchDetailsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellControllers[indexPath.item].cancelLoad()
    }
}

extension LaunchDetailsViewController: UICollectionViewDataSourcePrefetching {
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
