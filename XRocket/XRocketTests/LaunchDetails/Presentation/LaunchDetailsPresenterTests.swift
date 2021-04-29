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
        XCTAssertEqual(LaunchDetailsPresenter.title, launchDetailsLocalized("launch_details_view_title"))
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
        XCTAssertEqual(message, .image(LaunchDetailsImageViewModel(urls: [url])))
    }
    
    func test_populateLaunchDetails_sendDisplayLaunchDetailMessageToView() {
        let (sut, view) = makeSUT()
        let launch = LaunchFactory.any()
        sut.display(launch: launch)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message, .info(LaunchDetailsViewModel(name: launch.name, flightNumber: "\(launch.flightNumber)", success: launch.success, details: launch.details, rocketName: launch.rocket.name, launchDate: launch.dateUnix)))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchDetailsPresenter, ViewSpy) {
        let view = ViewSpy()
        let sut = LaunchDetailsPresenter(launchDetailsImageView: view, launchDetailsView: view)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy: LaunchDetailsImageView, LaunchDetailsView {
        enum Message: Equatable {
            case image(LaunchDetailsImageViewModel)
            case info(LaunchDetailsViewModel)
        }
        var messages = [Message]()
        
        func display(_ viewModel: LaunchDetailsImageViewModel) {
            messages.append(.image(viewModel))
        }
        
        func display(_ viewModel: LaunchDetailsViewModel) {
            messages.append(.info(viewModel))
        }
    }
}
