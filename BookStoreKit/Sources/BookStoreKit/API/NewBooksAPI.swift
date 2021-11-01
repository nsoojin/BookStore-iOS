//
//  NewBooksAPI.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import Networking

struct NewBooksAPI: API {
    typealias ResponseType = NewBooksResponse
    let configuration: APIConfiguration
    
    init() {
        configuration = APIConfiguration(base: BookStoreConfiguration.shared.baseURL,
                                         path: "/1.0/new")
    }
}
