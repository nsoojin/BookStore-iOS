//
//  SearchEngine.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// An object that searches for books with a given keyword from the IT Book Store.
///
/// Search results are paginated, and each page contains maximum of 10 results. You start a new search when search keyword changes by calling `func search(for:)`. The search result is delivered to you through delegate methods, so implement `SearchEngineDelegate`.
public final class SearchEngine {
    
    /// The search engine's delegate object.
    ///
    /// The delegate should conform to the `SearchEngineDelegate` protocol. Set this property to receive search results or get notified when the request executes. The delegate is not retained.
    weak public var delegate: SearchEngineDelegate?
    
    /// A boolean value indicating whether there are more results available.
    ///
    /// - note: You request for the next page with `func requestNextPage()`
    public var hasNextPage: Bool {
        return nextRequest != nil
    }
    
    /// Searches for books that contain the keyword.
    ///
    /// User input is typically handled in UITextFieldDelegate or UISearchBarDelegate. Use appropriate delegate methods to notify the search engine instance for keyword changes.
    ///
    ///     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    ///         if searchText.isEmpty == false {
    ///             searchEngine.search(for: searchText)
    ///         }
    ///     }
    ///
    /// - Parameter text: The keyword to search for.
    /// - important: Search requests are debounced for 0.3 seconds, which means the request executes 0.3 seconds after you call `func search(for:)`. If you call this method again before it executes, the previous one is cancelled. If you perform a new search before getting the result back, the previous one will be discarded and not be delievered to you.
    public func search(for text: String) {
        if text.isEmpty { return }
        
        searchText = text
        let request = SearchRequest(text: text, page: 1)
        
        debouncer.schedule { [weak self] in
            guard let self = self else { return }
            
            self.executeOnMainQueue { self.delegate?.searchEngine(self, didStart: request) }
            self._search(for: SearchRequest(text: text, page: 1))
        }
    }
    
    /// Fetches more results if there is any.
    ///
    /// Search results are paginated, so call this method to retrieve more results. If there are no more results, you will get `SearchError.endOfResult`. You can also check the availability with `var hasNextPage: Bool` beforehand.
    public func requestNextPage() {
        guard let request = nextRequest else {
            executeOnMainQueue { self.delegate?.searchEngine(self, didReceive: .failure(.endOfResult)) }
            return
        }
        
        if isSearching == false {
            _search(for: request)
        }
    }
    
    /// Initializes an instance of SearchEngine.
    public convenience init() {
        self.init(provider: ITBookStoreProvider())
    }
    
    /// Initializes a new instance with the specified delegate object.
    /// - Parameter delegate: The delegate object for this instance.
    public convenience init(delegate: SearchEngineDelegate) {
        self.init(provider: ITBookStoreProvider())
        self.delegate = delegate
    }
    
    init(provider: SearchResultsProviding) {
        self.provider = provider
    }
    
    private func _search(for request: SearchRequest) {
        if request.text.isEmpty { return }
        
        isSearching = true
        
        provider.search(for: request) { [weak self] (result) in
            guard let self = self else { return }
            
            result.success(self.responseHandler(for: request))
                  .catch(self.handle)
            
            self.isSearching = false
        }
    }
    
    private func responseHandler(for request: SearchRequest) -> (SearchBookResponse) -> Void {
        return { [weak self] (response) in
            self?.handle(response, fromRequest: request)
        }
    }
    
    private func handle(_ response: SearchBookResponse, fromRequest request: SearchRequest) {
        if request.text != searchText { return }
        
        nextRequest = nextRequest(from: response)
        
        let books = response.books
        if books.isEmpty {
            if response.page > 1 {
                executeOnMainQueue { self.delegate?.searchEngine(self, didReceive: .failure(.endOfResult)) }
            } else {
                executeOnMainQueue { self.delegate?.searchEngine(self, didReceive: .failure(.notFound)) }
            }
        } else {
            let result = SearchResult(books: books, searchText: request.text, page: response.page)
            executeOnMainQueue { self.delegate?.searchEngine(self, didReceive: .success(result)) }
        }
    }

    private func handle(_ error: Error) {
        executeOnMainQueue { self.delegate?.searchEngine(self, didReceive: .failure(.apiFailure(error))) }
    }
    
    private func nextRequest(from response: SearchBookResponse) -> SearchRequest? {
        if response.page > 1 && response.total == 0 { return nil }
        
        return SearchRequest(text: searchText, page: response.page + 1)
    }
    
    private func executeOnMainQueue(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
    
    private var searchText: String = ""
    private var isSearching: Bool = false
    private var nextRequest: SearchRequest?
    private let debouncer = Debouncer(label: "com.nsoojin.search.book", delay: 0.3)
    private let provider: SearchResultsProviding
}
