//
//  LaunchCellPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 21/4/21.
//

import XCTest
import XRocket

struct LaunchCellViewModel {
    
}

protocol LaunchCellView {
    func display(viewModel: LaunchCellViewModel)
}

class LaunchCellPresenter {
    private let view: LaunchCellView
    
    init(view: LaunchCellView) {
        self.view = view
    }
}

class LaunchCellPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchCellPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchCellPresenter(view: view)
        
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchCellView {
        private(set) var messages = [LaunchCellViewModel]()
        
        func display(viewModel: LaunchCellViewModel) {
            
        }
    }
}
