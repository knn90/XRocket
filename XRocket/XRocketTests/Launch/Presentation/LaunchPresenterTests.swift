//
//  LaunchPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 18/4/21.
//

import XCTest
import XRocket

class LaunchPresenterTests: XCTestCase {
    func test_title_shouldLocalized() {
        XCTAssertEqual(LaunchPresenter.title, launchLocalized("launch_view_title"))
    }
    
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingLaunch_displaysNoErrorMessageAndStartLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingLaunch()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: nil),
            .display(isLoading: true),
            .display(isLoading: true, hasNextPage: false, pageNumber: 0)
        ])
    }
    
    func test_didFinishLoadingWithError_displaysErrorAndStopLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: launchLocalized("launch_view_connection_error")),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithLaunches_displaysLaunchesAndStopLoading() {
        let (sut, view) = makeSUT()
        let launchPagination = LaunchPaginationFactory.single()
        let viewModel = LaunchViewModel(launches: launchPagination.docs, pageNumber: 1)
        sut.didFinishLoading(with: launchPagination)
        
        XCTAssertEqual(view.messages, [
            .display(launches: viewModel.launches),
            .display(isLoading: false),
            .display(isLoading: false, hasNextPage: launchPagination.hasNextPage, pageNumber: launchPagination.page)
        ])
    }
    
    func test_didStartLoadMoreLaunch_displayLoadMoreViewModel() {
        let (sut, view) = makeSUT()
        let launchPagination = LaunchPaginationFactory.single()
        sut.didStartLoadMoreLaunch(page: 1)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: true, hasNextPage: launchPagination.hasNextPage, pageNumber: launchPagination.page)
        ])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchPresenter(loadingView: view, errorView: view, launchView: view, loadMoreView: view)
        
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchLoadingView, LaunchErrorView, LaunchView, LaunchLoadMoreView {
        enum Message: Equatable {
            case display(isLoading: Bool)
            case display(errorMessage: String?)
            case display(launches: [Launch])
            case display(isLoading: Bool, hasNextPage: Bool, pageNumber: Int)
        }
        
        private(set) var messages = [Message]()
        
        func display(_ viewModel: LaunchLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: LaunchErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: LaunchViewModel) {
            messages.append(.display(launches: viewModel.launches))
        }
        
        func display(_ viewModel: LaunchLoadMoreViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading, hasNextPage: viewModel.hasNextPage, pageNumber: viewModel.pageNumber))
        }
    }
}
