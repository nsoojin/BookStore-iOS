//
//  BookInfo.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// A structure that contains detailed information about a book.
public struct BookInfo: Decodable {
    
    /// The title of the book.
    public let title: String
    
    /// The subtitle of the book.
    public let subtitle: String
    
    /// The authors of the book, separated by commas.
    public let authors: String
    
    /// The name of the publisher.
    public let publisher: String
    
    /// The language in which the book is written.
    public let language: String
    
    /// The unique ISBN-10 identifer of the book.
    public let isbn10: String?
    
    /// The unique ISBN-13 identifer of the book.
    public let isbn13: String
    
    /// The number pages of the book.
    public let pages: String
    
    /// The year when the book was published.
    public let year: String
    
    /// The rating of the book in IT Bookstore.
    public let rating: String
    
    /// The short description of the book.
    public let shortDescription: String
    
    /// The price of the book in dollars.
    public let price: String
    
    /// The URL path to the cover image of the book.
    public let thumbnailURL: URL?
    
    /// The URL path to a website in IT Bookstore to purchase.
    public let purchaseURL: URL?
    
    /// The error code of the request, if exists.
    public let error: String?
    
    enum CodingKeys: String, CodingKey {
        case title, subtitle, authors, publisher, language
        case isbn10, isbn13, pages, year, rating, error, price
        case shortDescription = "desc"
        case thumbnailURL = "image"
        case purchaseURL = "url"
    }
}

extension BookInfo: CustomStringConvertible {
    public var description: String {
        return "<BookInfo-\(title)>"
    }
}
