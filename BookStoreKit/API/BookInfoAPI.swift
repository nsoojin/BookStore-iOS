//
//  BookInfoAPI.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import Networking

struct BookInfoAPI: API {
    typealias ResponseType = BookInfo
    let configuration: APIConfiguration
    
    init(isbn13: String) {
        configuration = APIConfiguration(base: BookStoreConfiguration.shared.baseURL,
                                         path: "/1.0/books/\(isbn13)")
    }
}
