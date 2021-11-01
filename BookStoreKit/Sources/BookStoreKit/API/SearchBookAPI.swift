//
//  SearchBookAPI.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import Networking

struct SearchBookAPI: API {
    typealias ResponseType = SearchBookResponse
    let configuration: APIConfiguration
    
    init(searchText: String, page: Int) {
        configuration = APIConfiguration(base: BookStoreConfiguration.shared.baseURL,
                                         path: "/1.0/search/\(searchText)/\(page)")
    }
}
