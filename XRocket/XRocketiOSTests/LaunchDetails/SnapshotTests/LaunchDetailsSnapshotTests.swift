//
//  LaunchDetailsSnapshotTests.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 29/4/21.
//

import XCTest
import XRocket
@testable import XRocketiOS

class LaunchDetailsSnapshotTests: XCTestCase {
    func test_detailsWithEmptyImages() {
        let sut = makeSUT()
        
        sut.display(emptyImages())
        sut.populate(details())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "DETAIL_WITHOUT_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "DETAIL_WITHOUT_IMAGES_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITHOUT_IMAGES_light_ExtraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITHOUT_IMAGES_dark_ExtraExtraExtraLarge")
    }
    
    func test_detailsWithImages() {
        let sut = makeSUT()
        
        sut.display(images())
        sut.populate(details())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "DETAIL_WITH_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "DETAIL_WITH_IMAGES_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITH_IMAGES_light_ExtraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITH_IMAGES_dark_ExtraExtraExtraLarge")
    }
    
    func test_detailsWithErrorImages() {
        let sut = makeSUT()
        
        sut.display(imagesWithError())
        sut.populate(details())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "DETAIL_WITH_ERROR_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "DETAIL_WITH_ERROR_IMAGES_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITH_ERROR_IMAGES_light_ExtraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "DETAIL_WITH_ERROR_IMAGES_dark_ExtraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> LaunchDetailsViewController {
        let bundle = Bundle(for: LaunchDetailsViewController.self)
        let storyboard = UIStoryboard(name: "LaunchDetails", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LaunchDetailsViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyImages() -> [ImageStub] {
        return []
    }
    
    private func images() -> [ImageStub] {
        [ImageStub(
            isLoading: false,
            shouldRetry: false,
            image: UIImage.make(withColor: .blue))]
    }
    
    private func imagesWithError() -> [ImageStub] {
        [ImageStub(
            isLoading: false,
            shouldRetry: true,
            image: nil)]
    }
    
    private func details() -> [LaunchDetailsInfoCellController] {
        let viewModel = LaunchDetailsViewModel(name: "Starlink", flightNumber: "214", success: true, details: "This mission launches the 22nd batch of operational Starlink satellites, which are version 1.0, from or SLC-40. It is the 23rd Starlink launch overall. The satellites will be delivered to low Earth orbit and will spend a few weeks maneuvering to their operational altitude. The booster is expected to land on an ASDS.", rocketName: "Falcon 21", launchDate: Date(timeIntervalSince1970: 1616574480))
        let controller = LaunchDetailsInfoCellController(viewModel: viewModel)
        return [controller]
    }
}

private extension LaunchDetailsViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [LaunchDetailsImageCellController] = stubs.map { stub in
            let cellController = LaunchDetailsImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }
        
        self.display(cells)
    }
}

private class ImageStub: LaunchDetailsImageCellControllerDelegate {
    let viewModel: LaunchImageViewModel<UIImage>
    weak var controller: LaunchDetailsImageCellController?
    
    init(isLoading: Bool, shouldRetry: Bool, image: UIImage?) {
        viewModel = LaunchImageViewModel(image: image, isLoading: isLoading, shouldRetry: shouldRetry)
    }
    
    func didRequestImage() {
        controller?.display(viewModel: viewModel)
    }
    
    func didCancelImageRequest() {
    }
}
