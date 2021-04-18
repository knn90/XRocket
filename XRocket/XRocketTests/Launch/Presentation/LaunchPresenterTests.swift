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
        XCTAssertEqual(LaunchPresenter.title, localized("launch_view_title"))
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
            .display(isLoading: true)            
        ])
    }
    
    func test_didFinishLoadingWithError_displaysErrorAndStopLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("launch_view_connection_error")),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchPresenter(loadingView: view, errorView: view)
        
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchLoadingView, LaunchErrorView {
        enum Message: Equatable {
            case display(isLoading: Bool)
            case display(errorMessage: String?)
        }
        
        private(set) var messages = [Message]()
        
        func display(errorMessage: String?) {
            messages.append(.display(errorMessage: errorMessage))
        }
        
        func display(isLoading: Bool) {
            messages.append(.display(isLoading: isLoading))
        }
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Launch"
        let bundle = Bundle(for: LaunchPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
