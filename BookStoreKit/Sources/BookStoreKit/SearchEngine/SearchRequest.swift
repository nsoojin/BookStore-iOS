//
//  SearchRequest.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 13/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// A search request that finds books containing the keyword, with page number.
///
/// You do not create instances of this type directly. It is created by `SearchEngine` instance and delivered to you through `func searchEngine(_ engine:, didStart:)` delegate method. It is also included in `SearchResult` instance when the search is successful. You can use this information to track what request is being handled, and which request the search result is for.
public struct SearchRequest {
    
    /// The keyword for the search.
    public let text: String
    
    /// The page number to request.
    public let page: Int
}

extension SearchRequest: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "<SearchRequest: text=\(text), page=\(page)>"
    }
}
