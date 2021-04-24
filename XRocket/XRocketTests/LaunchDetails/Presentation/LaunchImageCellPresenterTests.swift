//
//  LaunchImageCellPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 23/4/21.
//

import XCTest
import XRocket


class LaunchImageCellPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingImage_displayLoadingImage() {
        let (sut, view) = makeSUT()
        sut.didStartLoadingImage()
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImage_displayRetryOnFailedTransformation() {
        let (sut, view) = makeSUT(imageTransformer: { _ in return nil } )
    
        sut.didFinishLoadingImage(with: Data())

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }

    func test_didFinishLoadingImageData_displaysImageOnSuccessfulTransformation() {
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })

        sut.didFinishLoadingImage(with: Data())

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformedData)
    }

    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let (sut, view) = makeSUT()

        sut.didFinishLoadingImage(with: anyNSError())

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertEqual(message?.image, nil)
    }

    
    // MARK: - Helpers
    private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil }, file: StaticString = #file, line: UInt = #line) -> (LaunchImageCellPresenter<ViewSpy, AnyImage>, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchImageCellPresenter(view: view, imageTransformer: imageTransformer)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        
        return (sut, view)
    }
    
    private struct AnyImage: Equatable {}
    
    private class ViewSpy: LaunchImageView {
        
        var messages = [LaunchImageViewModel<AnyImage>]()
        
        func display(viewModel: LaunchImageViewModel<AnyImage>) {
            messages.append(viewModel)
        }
    }
    
}
