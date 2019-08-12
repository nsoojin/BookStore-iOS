//
//  SearchEngineDelegate.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 13/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// A protocol defining methods that SearchEngine instances call to deliver search results, as well as notify request execution.
///
/// Delegate methods are executed on the main queue.
public protocol SearchEngineDelegate: AnyObject {
    
    /// Tells the delegate that a request started.
    ///
    /// Implement this method to get notified when the request is executed. This is especially useful because search requests are debounced, so the actual execution of search requests are delayed. Typically you may want to make UI changes here to indicate loading. This method is executed on the main queue.
    /// - Parameter engine: The search engine object requesting the search.
    /// - Parameter searchRequest: The request object containing the information about the search.
    func searchEngine(_ engine: SearchEngine, didStart searchRequest: SearchRequest)
    
    /// Tells the delegate that the request finished with the result.
    ///
    /// You should handle either the successful search result, or the error. This method is executed on the main queue.
    /// - Parameter engine: The search engine object requesting the search.
    /// - Parameter searchResult: A result containing either `SearchResult` object or `SearchError`.
    func searchEngine(_ engine: SearchEngine, didReceive searchResult: Result<SearchResult, SearchError>)
}
