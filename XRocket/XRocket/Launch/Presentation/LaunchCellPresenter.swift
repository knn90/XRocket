//
//  LaunchCellPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 22/4/21.
//

import Foundation

public protocol LaunchCellView {
    associatedtype Image
    func display(viewModel: LaunchCellViewModel<Image>)
}

public class LaunchCellPresenter<View: LaunchCellView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImage(for launch: Launch) {
        view.display(viewModel: LaunchCellViewModel(launch: launch, isLoading: true, image: nil))
    }
    
    public func didFinishLoadingImage(with data: Data, for launch: Launch) {
        let image = imageTransformer(data)
        view.display(viewModel: LaunchCellViewModel(launch: launch, isLoading: false, image: image))
    }
    
    public func didFinishLoadingImage(with error: Error, for launch: Launch) {
        view.display(viewModel: LaunchCellViewModel(launch: launch, isLoading: false, image: nil))
    }
}
