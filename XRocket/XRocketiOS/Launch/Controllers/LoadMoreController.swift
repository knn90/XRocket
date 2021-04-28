//
//  LoadMoreController.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 28/4/21.
//

import Foundation
import XRocket

public protocol LoadMoreControllerDelegate {
  func didRequestLoadMore(page: Int)
}

public final class LoadMoreController: LaunchLoadMoreView {
    
    private let delegate: LoadMoreControllerDelegate
    private var viewModel: LaunchLoadMoreViewModel?
    
    init(delegate: LoadMoreControllerDelegate) {
        self.delegate = delegate
    }
    
    func load() {
      guard let viewModel = viewModel, let nextPage = viewModel.nextPage, !viewModel.isLoading else { return }

      delegate.didRequestLoadMore(page: nextPage)
    }
    
    public func display(_ viewModel: LaunchLoadMoreViewModel) {
        self.viewModel = viewModel
    }
}
