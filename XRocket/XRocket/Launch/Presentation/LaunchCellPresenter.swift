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
    
    public func didStartLoadingImage(for launch: PresentableLaunch) {
        view.display(viewModel: LaunchCellViewModel(name: launch.name, flightNumber: launch.flightNumber, status: launch.status, launchDate: launch.launchDate, isLoading: true, image: nil))
    }
    
    public func didFinishLoadingImage(with data: Data, for launch: PresentableLaunch) {
        let image = imageTransformer(data)
        view.display(viewModel: LaunchCellViewModel(name: launch.name, flightNumber: launch.flightNumber, status: launch.status, launchDate: launch.launchDate, isLoading: false, image: image))
    }
    
    public func didFinishLoadingImage(with error: Error, for launch: PresentableLaunch) {
        view.display(viewModel: LaunchCellViewModel(name: launch.name, flightNumber: launch.flightNumber, status: launch.status, launchDate: launch.launchDate, isLoading: false, image: nil))
    }
}
