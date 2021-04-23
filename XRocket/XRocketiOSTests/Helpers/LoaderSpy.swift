//
//  LoaderSpy.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 23/4/21.
//

import Foundation
import XRocket

class LoaderSpy: LaunchLoader, ImageDataLoader {
    private(set) var loadLaunchCallCount = 0
    private(set) var completions = [(LaunchLoader.Result) -> Void]()
    
    func load(completion: @escaping (Result<LaunchPagination, Error>) -> Void) {
        loadLaunchCallCount += 1
        completions.append(completion)
    }
    
    func completeLoading(with launchPagination: LaunchPagination = LaunchPaginationFactory.empty(), at index: Int) {
        completions[index](.success(launchPagination))
    }
    
    func completeLoading(with error: Error, at index: Int) {
        completions[index](.failure(error))
    }
    
    // Image Loader
    private(set) var requestedImageURLs = [URL]()
    private(set) var cancelledImageURLs = [URL]()
    private(set) var imageCompletions = [(ImageDataLoader.Result) -> Void]()
    private struct TaskSpy: ImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
    func load(from request: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        requestedImageURLs.append(request.url!)
        imageCompletions.append(completion)
        return TaskSpy { [weak self] in
            self?.cancelledImageURLs.append(request.url!)
        }
    }
    
    func completeImageLoading(with data: Data = Data(), at index: Int) {
        imageCompletions[index](.success(data))
    }
    
    func completeImageLoading(with error: Error, at index: Int) {
        imageCompletions[index](.failure(error))
    }
}
