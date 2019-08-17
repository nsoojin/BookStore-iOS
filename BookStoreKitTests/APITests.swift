//
//  APITests.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
import Networking
@testable import BookStoreKit

class APITests: XCTestCase {
    lazy var client: APIClient = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        
        return APIClient(session: URLSession(configuration: config))
    }()
    
    func testNewBooks() {
        let apiExpectation = expectation(description: "New Books API expectation")
        
        NewBooksAPI().execute(using: client) { (result) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.total, "10")
                XCTAssertEqual(response.error, "0")
                XCTAssertEqual(response.books.count, 10)
                
                let book = response.books[0]
                XCTAssertEqual(book.title, "Learning C++ by Building Games with Unreal Engine 4, 2nd Edition")
                XCTAssertEqual(book.subtitle, "A beginner's guide to learning 3D game development with C++ and UE4")
                XCTAssertEqual(book.isbn13, "9781788476249")
                XCTAssertEqual(book.price, "$44.99")
                XCTAssertEqual(book.thumbnailURL, URL(string: "https://itbook.store/img/books/9781788476249.png"))
                XCTAssertEqual(book.purchaseURL, URL(string: "https://itbook.store/books/9781788476249"))
                XCTAssertEqual("\(book)", "<Book-Learning C++ by Building Games with Unreal Engine 4, 2nd Edition>")
                apiExpectation.fulfill()
            case .failure:
                ()
            }
        }
        
        wait(for: [apiExpectation], timeout: 0.5)
    }
    
    func testBookInfo() {
        let apiExpectation = expectation(description: "Book Info API expectation")
        
        let isbn13 = "9781788476249"
        BookInfoAPI(isbn13: isbn13).execute(using: client) { (result) in
            switch result {
            case .success(let bookInfo):
                XCTAssertEqual(bookInfo.title, "Learning C++ by Building Games with Unreal Engine 4, 2nd Edition")
                XCTAssertEqual(bookInfo.subtitle, "A beginner's guide to learning 3D game development with C++ and UE4")
                XCTAssertEqual(bookInfo.authors, "Sharan Volin")
                XCTAssertEqual(bookInfo.publisher, "Packt Publishing")
                XCTAssertEqual(bookInfo.language, "English")
                XCTAssertEqual(bookInfo.isbn10, "1788476247")
                XCTAssertEqual(bookInfo.isbn13, isbn13)
                XCTAssertEqual(bookInfo.pages, "468")
                XCTAssertEqual(bookInfo.year, "2018")
                XCTAssertEqual(bookInfo.rating, "0")
                XCTAssertEqual(bookInfo.shortDescription, "Learning to program in C++ requires some serious motivation. Unreal Engine 4 (UE4) is a powerful C++ engine with a full range of features used to create top-notch, exciting games by AAA studios, making it the fun way to dive into learning C++17.This book starts by installing a code editor so you can...")
                XCTAssertEqual(bookInfo.price, "$44.99")
                XCTAssertEqual(bookInfo.thumbnailURL, URL(string: "https://itbook.store/img/books/9781788476249.png"))
                XCTAssertEqual(bookInfo.purchaseURL, URL(string: "https://itbook.store/books/9781788476249"))
                XCTAssertEqual("\(bookInfo)", "<BookInfo-Learning C++ by Building Games with Unreal Engine 4, 2nd Edition>")
                apiExpectation.fulfill()
            case .failure:
                ()
            }
        }
        
        wait(for: [apiExpectation], timeout: 0.5)
    }
}
