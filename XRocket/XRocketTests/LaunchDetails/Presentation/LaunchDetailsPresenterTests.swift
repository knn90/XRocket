//
//  LaunchImageCellPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 23/4/21.
//

import XCTest
import XRocket


class LaunchDetailsPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(LaunchDetailsPresenter.title, localized("launch_details_view_title"))
    }
    
    func test_init_doesNotSendMessageToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_displayURL_sendDisplayMessageToView() {
        let (sut, view) = makeSUT()
        let url = anyURL()
        sut.display(urls: [url])
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.urls, [url])
    }
    
//    func test_populateLaunchDetails_sendDisplayLaunchDetailMessageToView() {
//        let (sut, view) = makeSUT()
//        let launch = LaunchFactory.any()
//        sut.display(launch: launch)
//        
//        let message = view.messages.first
//        XCTAssertEqual(view.messages.count, 1)
//        XCTAssertEqual(message?.urls, [url])
//    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchDetailsPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchDetailsPresenter(launchDetailsView: view)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchDetailsImageView {
        var messages = [LaunchDetailsImageViewModel]()
        
        func display(_ viewModel: LaunchDetailsImageViewModel) {
            messages.append(viewModel)
        }
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "LaunchDetails"
        let bundle = Bundle(for: LaunchDetailsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
