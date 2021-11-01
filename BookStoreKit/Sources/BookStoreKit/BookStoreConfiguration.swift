//
//  BookStoreConfiguration.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 25/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

/// Configuration for BookStore API. You have chance to change the base URL.
public class BookStoreConfiguration {
    
    /// The shared BookStoreConfiguration instance.
    ///
    /// You can also create instances of BookStore directly with `SearchEngine()` convenience initializer.
    public static let shared = BookStoreConfiguration(baseURL: URL(string: "https://api.itbook.store")!)
    
    /// The base URL for BookStore Requests.
    private(set) var baseURL: URL
    
    /// Sets the base URL for BookStore API endpoints.
    public func setBaseURL(_ url: URL) {
        self.baseURL = url
    }
    
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
}
