//
//  MockURLProtocol.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

typealias Path = String

class MockURLProtocol: URLProtocol {
    private static let mock: [Path: Data] = ["/1.0/new": MockData.newBooks,
                                             "/1.0/books/9781788476249": MockData.bookInfo,
                                             "/1.0/search/qazwsx/1": MockData.searchNotFound,
                                             "/1.0/search/dummies/1": MockData.searchDummies,
                                             "/1.0/search/dummies/2": MockData.searchEndOfResult]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let path = request.url?.path, let mockData = MockURLProtocol.mock[path] {
            client?.urlProtocol(self, didLoad: mockData)
        } else {
            client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

enum MockSessionError: Error {
    case notSupported
}
