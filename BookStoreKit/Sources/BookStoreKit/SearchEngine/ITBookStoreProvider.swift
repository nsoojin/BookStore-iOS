//
//  ITBookStoreProvider.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

struct ITBookStoreProvider: SearchResultsProviding {
    func search(for request: SearchRequest, completionHandler: @escaping SearchResultsHandler) {
        SearchBookAPI(searchText: request.text, page: request.page).execute(completionHandler)
    }
}
