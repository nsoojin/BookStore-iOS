//
//  SearchViewControllerTests.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 25/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
import Swifter

class SearchViewControllerTests: XCTestCase {
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

    func testTabController() {
        app.launch()
        app.tabBars.firstMatch.buttons["Search"].tap()
        
        XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 2), "Search textfield cancel button missing.")
        XCTAssert(app.keyboards.count > 0, "Keyboard should be shown.")
    }
}
