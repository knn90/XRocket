//
//  LaunchImageCellPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 23/4/21.
//

import Foundation

public protocol LaunchImageView {
    associatedtype Image
    
    func display(viewModel: LaunchImageViewModel<Image>)
}

public final class LaunchImageCellPresenter<View: LaunchImageView, Image> where View.Image == Image {
    private let view: View
    private let  imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImage() {
        view.display(viewModel: LaunchImageViewModel(image: nil, isLoading: true, shouldRetry: false))
    }
    
    public func didFinishLoadingImage(with data: Data) {
        if let image = imageTransformer(data) {
            view.display(viewModel: LaunchImageViewModel(image: image, isLoading: false, shouldRetry: false))
        } else {
            view.display(viewModel: LaunchImageViewModel(image: nil, isLoading: false, shouldRetry: true))
        }
    }
    
    public func didFinishLoadingImage(with error: Error) {
        view.display(viewModel: LaunchImageViewModel(image: nil, isLoading: false, shouldRetry: true))
    }
}
