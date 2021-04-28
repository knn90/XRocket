//
//  LaunchLoadMoreViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 28/4/21.
//

import Foundation

public struct LaunchLoadMoreViewModel {
    public let isLoading: Bool
    public let hasNextPage: Bool
    public let pageNumber: Int

    public var nextPage: Int? {
        hasNextPage ? pageNumber + 1 : nil
    }
    
    public init(isLoading: Bool, hasNextPage: Bool, pageNumber: Int) {
      self.isLoading = isLoading
      self.hasNextPage = hasNextPage
      self.pageNumber = pageNumber
    }
}
