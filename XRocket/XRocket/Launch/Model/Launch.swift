//
//  Launch.swift
//  XRocket
//
//  Created by Khoi Nguyen on 16/4/21.
//

import Foundation

public struct Launch: Codable, Equatable {
    public let id: String
    public let name: String
    public let flightNumber: Int
    public let success: Bool
    public let dateUTC: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case flightNumber = "flight_number"
        case success = "success"
        case dateUTC = "date_utc"
    }
    
    public init(id: String, name: String, flightNumber: Int, success: Bool, dateUTC: Date) {
        self.id = id
        self.name = name
        self.flightNumber = flightNumber
        self.success = success
        self.dateUTC = dateUTC
    }
}
