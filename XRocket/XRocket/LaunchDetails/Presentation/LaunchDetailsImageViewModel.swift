//
//  LaunchDetailsViewModel.swift
//  XRocket
//
//  Created by Khoi Nguyen on 24/4/21.
//

import Foundation

public struct LaunchDetailsImageViewModel: Equatable {
    public let urls: [URL]
    
    public init(urls: [URL]) {
        self.urls = urls
    }
    
}
