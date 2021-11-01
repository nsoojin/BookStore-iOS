//
//  NewBooksResponse.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 15/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// A structure that contains information about new releases books.
public struct NewBooksResponse: Decodable {
    
    /// The collection of new books.
    public let books: [Book]
    
    /// The total count of books for this response.
    public let total: String
    
    /// The error code of the request.
    ///
    /// - note: Error code "0" means no error.
    public let error: String
}
