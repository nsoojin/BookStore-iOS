//
//  SearchError.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// An error that occurs during searching books.
public enum SearchError: LocalizedError {
    
    /// An error indicating that the search yields empty result.
    case notFound
    
    /// An error indicating there are no more result to return.
    case endOfResult
    
    /// An error indicating network failure.
    case apiFailure(Error)
    
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Your search did not have any results."
        case .endOfResult:
            return "This is the end of the result."
        case .apiFailure(let error):
            return "Something went wrong from server. (\(error.localizedDescription))"
        }
    }
}

extension SearchError: Equatable {
    public static func == (lhs: SearchError, rhs: SearchError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound):
            return true
        case (.endOfResult, .endOfResult):
            return true
        default:
            return false
        }
    }
}
