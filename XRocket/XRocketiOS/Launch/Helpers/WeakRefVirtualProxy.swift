//
//  WeakRefVirtualProxy.swift
//  XRocketiOS
//
//  Created by Khoi Nguyen on 20/4/21.
//

import UIKit
import XRocket

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: LaunchView where T: LaunchView {
    func display(_ viewModel: LaunchViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchErrorView where T: LaunchErrorView {
    func display(_ viewModel: LaunchErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchLoadingView where T: LaunchLoadingView {
    func display(_ viewModel: LaunchLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchCellView where T: LaunchCellView, T.Image == UIImage {
    func display(viewModel: LaunchCellViewModel<UIImage>) {
        object?.display(viewModel: viewModel)
    }
}

extension WeakRefVirtualProxy: LaunchImageView where T: LaunchImageView, T.Image == UIImage {
    func display(viewModel: LaunchImageViewModel<UIImage>) {
        object?.display(viewModel: viewModel)
    }
}
