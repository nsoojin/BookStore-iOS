//
//  SearchRequestTests.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStoreKit

class SearchRequestTests: XCTestCase {

    func testSearchRequest() {
        let request = SearchRequest(text: "hello", page: 3)
        
        XCTAssertEqual(request.text, "hello")
        XCTAssertEqual(request.page, 3)
        XCTAssertEqual(request.debugDescription, "<SearchRequest: text=hello, page=3>")
    }
}
