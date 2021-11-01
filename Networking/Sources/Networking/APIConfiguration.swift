//
//  APIConfiguration.swift
//  BookStore
//
//  Created by Soojin Ro on 11/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public struct APIConfiguration {
    public let method: HTTPMethod
    public let url: URL
    public let parameters: [String: Any]?
    
    public init(method: HTTPMethod = .get,
                base: URL,
                path: String,
                parameters: [String: Any]? = nil) {
        self.method = method
        self.url = base.appendingPathComponent(path)
        self.parameters = parameters
    }
}
