//
//  File.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation
import XRocket

class LaunchPaginationFactory {
    
    static func single(with launches: [Launch] = [
        LaunchFactory.any(),
        LaunchFactory.emptyName(),
        LaunchFactory.launchFailed(),
    ]) -> LaunchPagination {
        LaunchPagination(
            docs: launches,
            totalDocs: 3,
            limit: 3,
            totalPages: 1,
            page: 1,
            pagingCounter: 1,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil)
    }
    
    static func multiple(with launches: [Launch] = [
        LaunchFactory.any(),
        LaunchFactory.emptyName(),
        LaunchFactory.launchFailed(),
    ], page: Int) -> LaunchPagination {
        LaunchPagination(
            docs: launches,
            totalDocs: 3,
            limit: 3,
            totalPages: 10,
            page: page,
            pagingCounter: 1,
            hasPrevPage: true,
            hasNextPage: true,
            prevPage: nil,
            nextPage: 2)
    }
    
    static func empty() -> LaunchPagination {
        LaunchPagination(
            docs: [],
            totalDocs: 0,
            limit: 0,
            totalPages: 1,
            page: 1,
            pagingCounter: 1,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil)
    }
}

extension LaunchPagination {
    func toJSONData() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
