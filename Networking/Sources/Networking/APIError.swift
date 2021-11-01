//
//  APIError.swift
//  BookStore
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

public enum APIError: LocalizedError {
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error has occured."
        }
    }
}
