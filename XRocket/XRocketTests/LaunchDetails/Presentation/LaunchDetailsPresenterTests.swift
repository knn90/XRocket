//
//  LaunchImageCellPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 23/4/21.
//

import XCTest

protocol LaunchDetailsView {
    
}

final class LaunchImageCellPresenter {
    private let view: LaunchDetailsView
    
    init(view: LaunchDetailsView) {
        self.view = view
    }
}

class LaunchImageCellPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchImageCellPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchImageCellPresenter(view: view)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchDetailsView {
        var messages = [Any]()
    }
}
