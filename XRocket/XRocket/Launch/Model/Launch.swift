//
//  Launch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public struct Launch: Codable, Equatable {
    public init(id: String, name: String, details: String) {
        self.id = id
        self.name = name
        self.details = details
    }
    
    let id: String
    let name: String
    let details: String
}
