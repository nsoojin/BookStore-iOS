//
//  SearchEngineTests.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStoreKit

class SearchEngineTests: XCTestCase {
    let searchEngine = SearchEngine(provider: MockSearchResultsProvider())
    
    var didStartTest: ((SearchRequest) -> Void)?
    var didReceiveResultTest: ((Result<SearchResult, SearchError>) -> Void)?
    var didStartExpectation: XCTestExpectation?
    var didReceiveExpectation: XCTestExpectation?
    
    override func setUp() {
        searchEngine.delegate = self
        
        didStartExpectation = expectation(description: "Search Did Start")
        didReceiveExpectation = expectation(description: "Search Did Receive")
    }
    
    override func tearDown() {
        didStartTest = nil
        didReceiveResultTest = nil
        
        didStartExpectation = nil
        didReceiveExpectation = nil
    }

    func testSearch() {
        didStartTest = { request in
            XCTAssertEqual(request.text, "hello")
            XCTAssertEqual(request.page, 1)
        }

        searchEngine.search(for: "h")
        searchEngine.search(for: "he")
        searchEngine.search(for: "hel")
        searchEngine.search(for: "hell")
        searchEngine.search(for: "hello")
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testNotFound() {
        didStartTest = { request in
            XCTAssertEqual(request.text, "qazwsx")
            XCTAssertEqual(request.page, 1)
        }
        
        didReceiveResultTest = { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error, .notFound)
                XCTAssertEqual(error.errorDescription, "Your search did not have any results.")
            } else {
                XCTFail("SearchEngine should be notFound")
            }
        }
        
        searchEngine.search(for: "qazwsx")
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testResult() {
        didStartTest = { request in
            XCTAssertEqual(request.text, "dummies")
            XCTAssertEqual(request.page, 1)
        }
        
        didReceiveResultTest = { result in
            if case let .success(response) = result {
                XCTAssertEqual(response.request.text, "dummies")
                XCTAssertEqual(response.request.page, 1)
                XCTAssertEqual(response.books.count, 10)
                XCTAssertTrue(self.searchEngine.hasNextPage)
            } else {
                XCTFail("Search Result should be success")
            }
        }
        
        searchEngine.search(for: "dummies")
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testEndOfResult() {
        let tempExpectation = expectation(description: "Page 1 request")
        
        didReceiveResultTest = { _ in
            tempExpectation.fulfill()
        }
        
        searchEngine.search(for: "dummies")
        
        wait(for: [tempExpectation], timeout: 0.5)
        
        didStartTest = { request in
            XCTAssertEqual(request.text, "dummies")
            XCTAssertEqual(request.page, 2)
        }
        
        didReceiveResultTest = { result in
            if case let .failure(error) = result {
                XCTAssertEqual(error, .endOfResult)
                XCTAssertEqual(error.errorDescription, "This is the end of the result.")
            } else {
                XCTFail("Search Result should be endOfResult")
            }
            
            XCTAssertFalse(self.searchEngine.hasNextPage)
        }
        
        searchEngine.requestNextPage()
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testApiFailure() {
        didStartTest = { request in
            XCTAssertEqual(request.text, "0000")
            XCTAssertEqual(request.page, 1)
        }
        
        didReceiveResultTest = { result in
            if case let .failure(apiError) = result {
                if case let .apiFailure(error as NSError) = apiError {
                    XCTAssertEqual(error.domain, "SearchError")
                    XCTAssertEqual(error.code, 1111)
                    XCTAssertTrue(error.userInfo.isEmpty)
                } else {
                    XCTFail("Search Result should be API Failure")
                }
            } else {
                XCTFail("Search Result should be failure")
            }
        }
        
        searchEngine.search(for: "0000")
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}

extension SearchEngineTests: SearchEngineDelegate {
    func searchEngine(_ engine: SearchEngine, didStart searchRequest: SearchRequest) {
        didStartTest?(searchRequest)
        didStartExpectation?.fulfill()
    }
    
    func searchEngine(_ engine: SearchEngine, didReceive searchResult: Result<SearchResult, SearchError>) {
        didReceiveResultTest?(searchResult)
        didReceiveExpectation?.fulfill()
    }
}
