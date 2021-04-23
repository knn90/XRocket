//
//  LaunchImageViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 23/4/21.
//

import Foundation

public struct LaunchImageViewModel<Image> {
    public let image: Image?
    public let isLoading: Bool
    public let isRetry: Bool
}
