//
//  SearchResultsProviding.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

typealias SearchResultsHandler = (Result<SearchBookResponse, Error>) -> Void

protocol SearchResultsProviding {
    func search(for request: SearchRequest, completionHandler: @escaping SearchResultsHandler)
}
