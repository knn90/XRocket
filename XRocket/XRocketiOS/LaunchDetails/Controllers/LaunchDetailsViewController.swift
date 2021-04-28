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
    func populateLaunchDetails()
}

public final class LaunchDetailsViewController: UIViewController {
    
    @IBOutlet private(set) public var collectionView: UICollectionView!
    @IBOutlet private(set) public var tableView: UITableView!
    
    var delegate: LaunchDetailsViewControllerDelegate?
    private var imageControllers = [LaunchDetailsImageCellController]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var infoControllers = [LaunchDetailsInfoCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private struct Constants {
        static let collectionHeight: CGFloat = 300
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createCollectionViewLayout()
        delegate?.requestForImageURLs()
        delegate?.populateLaunchDetails()
    }
    
    public func display(_ cellControllers: [LaunchDetailsImageCellController]) {
        self.imageControllers = cellControllers
    }
    
    public func populate(_ cellControllers: [LaunchDetailsInfoCellController]) {
        self.infoControllers = cellControllers
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
        return imageControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return imageControllers[indexPath.item].view(in: collectionView, at: indexPath)
    }
}

extension LaunchDetailsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageControllers[indexPath.item].cancelLoad()
    }
}

extension LaunchDetailsViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            imageControllers[indexPath.item].preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            imageControllers[indexPath.item].cancelLoad()
        }
    }
}

extension LaunchDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoControllers.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        infoControllers[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
}

public class LaunchDetailsInfoCellController: NSObject {
    private var cell: LaunchDetailsInfoCell?
    private let viewModel: LaunchDetailsViewModel
    
    init(viewModel: LaunchDetailsViewModel) {
        self.viewModel = viewModel
    }
}

extension LaunchDetailsInfoCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchDetailsInfoCell") as! LaunchDetailsInfoCell
        cell.nameLabel.text = viewModel.name
        cell.launchDateLabel.text = viewModel.launchDateString
        cell.rocketNameLabel.text = viewModel.rocketName
        cell.statusLabel.text = viewModel.status
        cell.descriptionLabel.text = viewModel.details
        self.cell = cell
        return cell
    }
}
