//
//  SearchBookResponse.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 14/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

struct SearchBookResponse: Decodable {
    let total: Int
    let page: Int
    let error: String
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case error, total, page, books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let totalString = try container.decode(String.self, forKey: .total)
        if let totalInt = Int(totalString) {
            total = totalInt
        } else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: [CodingKeys.total], debugDescription: "total could not be converted to Int type"))
        }
        
        let pageString = try container.decodeIfPresent(String.self, forKey: .page)
        if let pageInt = pageString.flatMap(Int.init) {
            page = pageInt
        } else {
            page = 0
        }
        
        error = try container.decode(String.self, forKey: .error)
        books = try container.decode([Book].self, forKey: .books)
    }
}
