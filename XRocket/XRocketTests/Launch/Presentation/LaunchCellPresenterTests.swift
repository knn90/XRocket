//
//  LaunchCellPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 21/4/21.
//

import XCTest
import XRocket

class LaunchCellPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImage_displayLoadingImage() {
        let (sut, view) = makeSUT()
        let launch = makeLaunch()
        
        sut.didStartLoadingImage(for: launch)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, launch.name)
        XCTAssertEqual(message?.flightNumber, launch.flightNumber)
        XCTAssertEqual(message?.status, launch.status)
        XCTAssertEqual(message?.launchDate, launch.launchDate)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImage_displayNoImageOnFailedTransformation() {
        let (sut, view) = makeSUT(imageTransformer: { _ in return nil } )
        let launch = makeLaunch()
        
        sut.didFinishLoadingImage(with: Data(), for: launch)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, launch.name)
        XCTAssertEqual(message?.flightNumber, launch.flightNumber)
        XCTAssertEqual(message?.status, launch.status)
        XCTAssertEqual(message?.launchDate, launch.launchDate)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageData_displaysImageOnSuccessfulTransformation() {
        let launch = makeLaunch()
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })
        
        sut.didFinishLoadingImage(with: Data(), for: launch)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, launch.name)
        XCTAssertEqual(message?.flightNumber, launch.flightNumber)
        XCTAssertEqual(message?.status, launch.status)
        XCTAssertEqual(message?.launchDate, launch.launchDate)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.image, transformedData)
    }
    
    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let launch = makeLaunch()
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImage(with: anyNSError(), for: launch)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.name, launch.name)
        XCTAssertEqual(message?.flightNumber, launch.flightNumber)
        XCTAssertEqual(message?.status, launch.status)
        XCTAssertEqual(message?.launchDate, launch.launchDate)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.image, nil)
    }
    
    // MARK: - Helpers
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil }, file: StaticString = #file, line: UInt = #line) -> (LaunchCellPresenter<ViewSpy, AnyImage>, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchCellPresenter(view: view, imageTransformer: imageTransformer)
        
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private struct AnyImage: Equatable {}
    
    private class ViewSpy: LaunchCellView {
        private(set) var messages = [LaunchCellViewModel<AnyImage>]()
        
        func display(viewModel: LaunchCellViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }
    
    private func makeLaunch() -> PresentableLaunch {
        PresentableLaunch(id: "id", name: "name", flightNumber: "4", status: "success", launchDate: "2021-02-01", imageURL: URL(string: "http://url.com")!)
    }
}
