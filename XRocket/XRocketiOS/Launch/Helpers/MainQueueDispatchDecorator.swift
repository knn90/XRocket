//
//  MainQueueDispatchDecorator.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 22/4/21.
//

import Foundation
import XRocket

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        if Thread.isMainThread {
            completion()
        } else {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension MainQueueDispatchDecorator: LaunchLoader where T == LaunchLoader {
    func load(request: URLRequest, completion: @escaping (Result<LaunchPagination, Error>) -> Void) {
        decoratee.load(request: request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == ImageDataLoader {
    func load(from request: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        decoratee.load(from: request) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
