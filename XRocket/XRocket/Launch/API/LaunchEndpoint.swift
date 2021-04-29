//
//  LaunchEndpoint.swift
//  XRocket
//
//  Created by Khoi Nguyen on 29/4/21.
//

import Foundation

public class LaunchEndpoint {
    public static func makeRequest(page: Int) -> URLRequest {
        let url = URL(string: "https://api.spacexdata.com/v4/launches/query")!
        var launchRequest = URLRequest(url: url)
        launchRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        launchRequest.httpMethod = "POST"
        let params: [String: Any] = [
            "query": [
                "upcoming": false
            ],
            "options": [
                "sort": [
                    "date_utc": "desc"
                ],
                "populate": [
                    [
                        "path": "rocket",
                        "select": [
                            "name": 1
                        ]
                    ]
                ],
                "page": page
            ]
        ]
        
        launchRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        return launchRequest
    }
}
