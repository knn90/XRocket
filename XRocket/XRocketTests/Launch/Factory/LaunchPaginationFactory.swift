//
//  File.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

class LaunchPaginationFactory {
    static func empty() -> LaunchPagination {
        LaunchPagination(
            docs: [],
            totalDocs: 0,
            offset: 0,
            limit: 0,
            totalPages: 0,
            page: 0,
            pagingCounter: 0,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil)
    }
    
    static func singlePage() -> LaunchPagination {
        LaunchPagination(
            docs: [
                LaunchFactory.any(),
                LaunchFactory.emptyName(),
                LaunchFactory.emptyDetails(),
            ],
            totalDocs: 3,
            offset: 0,
            limit: 3,
            totalPages: 1,
            page: 1,
            pagingCounter: 1,
            hasPrevPage: false,
            hasNextPage: false,
            prevPage: nil,
            nextPage: nil)
    }
}