//
//  LaunchPresenter.swift
//  XRocket
//
//  Created by Khoi Nguyen on 18/4/21.
//

import Foundation

public protocol ViewType {
    
}

public final class LaunchPresenter {
    public static var title: String {
        NSLocalizedString("launch_view_title",
                          tableName: "Launch",
                          bundle: Bundle(for: LaunchPresenter.self),
                          comment: "Title for the launch view")
    }
    
    public init(view: ViewType) {
    }
}
