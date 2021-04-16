//
//  LaunchPagination.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public struct LaunchPagination: Codable, Equatable {
    let docs: [Launch]
    let totalDocs: Int
    let offset: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let pagingCounter: Int
    let hasPrevPage: Bool
    let hasNextPage: Bool
    let prevPage: Int?
    let nextPage: Int?
    
    public init(docs: [Launch], totalDocs: Int, offset: Int, limit: Int, totalPages: Int, page: Int, pagingCounter: Int, hasPrevPage: Bool, hasNextPage: Bool, prevPage: Int?, nextPage: Int?) {
        self.docs = docs
        self.totalDocs = totalDocs
        self.offset = offset
        self.limit = limit
        self.totalPages = totalPages
        self.page = page
        self.pagingCounter = pagingCounter
        self.hasPrevPage = hasPrevPage
        self.hasNextPage = hasNextPage
        self.prevPage = prevPage
        self.nextPage = nextPage
    }
}
