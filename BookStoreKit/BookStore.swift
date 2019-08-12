//
//  BookStore.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// Provides features such as search, new releases, and detail book information.
///
/// Three main features of BookStore are
/// - Fetching new releases books.
/// - Fetching detail information of a book.
/// - Searching books for a keyword.
public struct BookStore {
    
    /// The default search engine object. Use this to search specific books for a keyword.
    ///
    /// You can also create instances of BookStore directly with `SearchEngine()` convenience initializer.
    public static let defaultSearchEngine = SearchEngine()
    
    /// Fetches new releases books.
    ///
    /// The result will contain 10 books, if not an error.
    ///
    /// - Parameter completionHandler: The completion handler to call when the fetch request is complete. This handler is executed on the main queue.
    public static func fetchNewReleases(completionHandler: @escaping (Result<NewBooksResponse, Error>) -> Void) {
        NewBooksAPI().execute(completionHandler)
    }
    
    /// Fetches book details using ISBN-13 as identifier.
    ///
    /// - Parameter isbn13: The ISBN-13 identifier of the book to fetch.
    /// - Parameter completionHandler: The completion handler to call when the fetch request is complete. This handler is executed on the main queue.
    public static func fetchInfo(with isbn13: String, completionHandler: @escaping (Result<BookInfo, Error>) -> Void) {
        BookInfoAPI(isbn13: isbn13).execute(completionHandler)
    }
}
