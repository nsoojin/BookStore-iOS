//
//  ITBookStoreService.swift
//  BookStore
//
//  Created by Soojin Ro on 17/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import BookStoreKit

struct ITBookStoreService: BookStoreService {
    var searchEngine: SearchEngine {
        return BookStore.defaultSearchEngine
    }
    
    func fetchNewReleases(completionHandler: @escaping (Result<NewBooksResponse, Error>) -> Void) {
        BookStore.fetchNewReleases(completionHandler: completionHandler)
    }
    
    func fetchInfo(with isbn13: String, completionHandler: @escaping (Result<BookInfo, Error>) -> Void) {
        BookStore.fetchInfo(with: isbn13, completionHandler: completionHandler)
    }
}
