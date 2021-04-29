//
//  LaunchSnapshotTests.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 29/4/21.
//

import XCTest
import XRocket
@testable import XRocketiOS

class LaunchSnapshotTests: XCTestCase {
    func test_emptyLaunch() {
        let sut = makeSUT()
        
        sut.set(emptyLaunch())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_LAUNCH_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_LAUNCH_dark")
    }
    
    func test_loadingLaunch() {
        let sut = makeSUT()
        
        sut.display(LaunchLoadingViewModel(isLoading: true))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LOADING_LAUNCH_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LOADING_LAUNCH_dark")
    }
    
    func test_launches() {
        let sut = makeSUT()
        
        sut.set(launches())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LAUNCH_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LAUNCH_LIST_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_light_ExtraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_dark_ExtraExtraExtraLarge")
    }
    
    func test_launches_reloads() {
        let sut = makeSUT()
        
        sut.set(launches())
        sut.display(.init(isLoading: true))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LAUNCH_LIST_RELOAD_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LAUNCH_LIST_RELOAD_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_RELOAD_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_RELOAD_dark_extraExtraExtraLarge")
    }
    
    func test_loadError() {
        let sut = makeSUT()
        
        sut.display(LaunchErrorViewModel(message: "this is \na multi-line \nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LAUNCH_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LAUNCH_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_ERROR_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_ERROR_dark_extraExtraExtraLarge")
    }
    
    func test_launchesWithError() {
        let sut = makeSUT()
        sut.set(launches())
        sut.display(LaunchErrorViewModel(message: "this is \na multi-line \nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LAUNCH_LIST_WITH_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LAUNCH_LIST_WITH_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_WITH_ERROR_light_extraExtraExtraLarge")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark, contentSizeCategory: .extraExtraExtraLarge)), named: "LAUNCH_LIST_WITH_ERROR_dark_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> LaunchViewController {
        let bundle = Bundle(for: LaunchViewController.self)
        let storyboard = UIStoryboard(name: "Launch", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LaunchViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyLaunch() -> [LaunchCellStub] {
        return []
    }
    
    private func launches() -> [LaunchCellStub] {
        return [
            LaunchCellStub(launch: LaunchFactory.fullDetails(), image: UIImage.make(withColor: .red)),
            LaunchCellStub(launch: LaunchFactory.fullDetails(), image: UIImage.make(withColor: .gray)),
            LaunchCellStub(launch: LaunchFactory.fullDetails(), image: UIImage.make(withColor: .blue)),
            LaunchCellStub(launch: LaunchFactory.fullDetails(), image: UIImage.make(withColor: .green)),
            LaunchCellStub(launch: LaunchFactory.fullDetails(), image: UIImage.make(withColor: .yellow))
        ]
    }
}

private extension LaunchViewController {
    func set(_ stubs: [LaunchCellStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = LaunchCellController(delegate: stub, didSelectCell: {})
            stub.controller = cellController
            return CellController(id: UUID(), cellController)
        }
        
        self.set(cells)
    }
}

private class LaunchCellStub: LaunchCellControllerDelegate {
    let viewModel: LaunchCellViewModel<UIImage>
    weak var controller: LaunchCellController?
    
    init(launch: Launch, image: UIImage?) {
        viewModel = LaunchCellViewModel(
            launch: launch,
            isLoading: false,
            image: image)
    }
    
    func didRequestImage() {
        controller?.display(viewModel: viewModel)
    }
    
    func didCancelImageRequest() {
    }
}
