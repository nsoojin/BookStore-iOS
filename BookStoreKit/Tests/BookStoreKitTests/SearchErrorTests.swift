//
//  SearchErrorTests.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 17/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStoreKit

class SearchErrorTests: XCTestCase {
    func testEquatable() {
        let notFound1 = SearchError.notFound
        let notFound2 = SearchError.notFound
        let endOfResult1 = SearchError.endOfResult
        let endOfResult2 = SearchError.endOfResult
        let apiError = SearchError.apiFailure(NSError(domain: "test", code: 0, userInfo: nil))
        let apiError1 = SearchError.apiFailure(NSError(domain: "test", code: 0, userInfo: nil))
        let apiError2 = SearchError.apiFailure(NSError(domain: "test-1", code: 9999, userInfo: nil))
        
        XCTAssertEqual(notFound1, notFound2)
        XCTAssertEqual(endOfResult1, endOfResult2)
        XCTAssertNotEqual(notFound1, endOfResult1)
        XCTAssertNotEqual(apiError, apiError1)
        XCTAssertNotEqual(apiError1, apiError2)
    }
}
