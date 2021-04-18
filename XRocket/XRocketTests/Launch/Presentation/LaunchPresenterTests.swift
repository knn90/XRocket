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
        let (sut, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchPresenter(view: view)
        
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: ViewType {
        enum Message {
            
        }
        private(set) var messages = [Message]()
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
