//
//  MockSearchResultsProvider.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import Networking
@testable import BookStoreKit

struct MockSearchResultsProvider: SearchResultsProviding {
    func search(for request: SearchRequest, completionHandler: @escaping SearchResultsHandler) {
        SearchBookAPI(searchText: request.text, page: request.page).execute(using: client, completionHandler)
    }
    
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        client = APIClient(session: URLSession(configuration: config))
    }
    
    private let client: APIClient
}
