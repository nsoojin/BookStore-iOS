//
//  BookStoreService.swift
//  BookStore
//
//  Created by Soojin Ro on 17/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import BookStoreKit

protocol BookStoreService {
    var searchEngine: SearchEngine { get }
    func fetchNewReleases(completionHandler: @escaping (Result<NewBooksResponse, Error>) -> Void)
    func fetchInfo(with isbn13: String, completionHandler: @escaping (Result<BookInfo, Error>) -> Void)
}
