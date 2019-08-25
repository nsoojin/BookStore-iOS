//
//  NewBooksViewControllerTests.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStore
import Swifter

private let itBookStoreHost = "api.itbook.store"
private let newBooksPath = "/1.0/new"

class NewBooksViewControllerTests: XCTestCase {
    var app = XCUIApplication()
    let server = HttpServer()

    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["-uitesting"]
    }
    
    override func tearDown() {
        server.stop()
    }

    func testNewBooksNormal() {
        do {
            let path = try TestUtil.path(for: "NewBooksNormal.json", in: type(of: self))
            server["/1.0/new"] = shareFile(path)
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.staticTexts["9781788476249"].waitForExistence(timeout: 5))
        XCTAssert(app.staticTexts["$44.99"].waitForExistence(timeout: 5))
    }
}
