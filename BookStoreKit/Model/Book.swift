//
//  Book.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// A structure that represents a book.
public struct Book: Decodable {
    
    /// The title of the book.
    public let title: String
    
    /// The subtitle of the book.
    public let subtitle: String
    
    /// The price of the book in dollars.
    public let price: String
    
    /// The unique ISBN-13 identifier of the book.
    public let isbn13: String
    
    /// The URL path to the cover image of the book.
    public let thumbnailURL: URL?
    
    /// The URL path to a website in IT Bookstore to purchase.
    public let purchaseURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title, subtitle, isbn13, price
        case thumbnailURL = "image"
        case purchaseURL = "url"
    }
}

extension Book: CustomStringConvertible {
    public var description: String {
        return "<Book-\(title)>"
    }
}
