//
//  SearchViewControllerTests.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 25/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
import Swifter

private let django123SearchPath = "/1.0/search/django123/1"
private let djangoSearchPath = "/1.0/search/django/1"
private let bookInfoPath = "/1.0/books/9781783984404"

private let emptySearchJSONFilename = "django123.json"
private let normalSearchJSONFilename = "django.json"
private let bookInfoJSONFilename = "bookInfo.json"

private let searchTableViewIdentifier = "SearchTableView"

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

    func testCancel() {
        app.launch()
        moveToSearchTab()
        
        app.buttons["Cancel"].tap()
        XCTAssert(app.keyboards.count == 0, "Keyboard should have dismissed.")
    }
    
    func testSearchButton() {
        app.launch()
        moveToSearchTab()
        
        app.searchFields["Search"].typeText(XCUIKeyboardKey.return.rawValue)
        XCTAssert(app.buttons["Cancel"].exists == false, "Cancel button should disappear.")
        XCTAssert(app.keyboards.count == 0, "Keyboard should dismiss.")
    }
    
    func testEmptySearch() {
        do {
            let emptySearchJSONPath = try TestUtil.path(for: emptySearchJSONFilename, in: type(of: self))
            server[django123SearchPath] = shareFile(emptySearchJSONPath)
            
            try server.start()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        app.launch()
        moveToSearchTab()

        app.searchFields["Search"].typeText("django123")
        XCTAssert(app.staticTexts["Your search did not have any results."].waitForExistence(timeout: 2))
    }
    
    func testSearch() {
        do {
            let searchJSONPath = try TestUtil.path(for: normalSearchJSONFilename, in: type(of: self))
            server[djangoSearchPath] = shareFile(searchJSONPath)
            
            let bookInfoJSONPath = try TestUtil.path(for: bookInfoJSONFilename, in: type(of: self))
            server[bookInfoPath] = shareFile(bookInfoJSONPath)
            
            try server.start()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        app.launch()
        moveToSearchTab()
        
        app.searchFields["Search"].typeText("django")
        XCTAssert(app.tables[searchTableViewIdentifier].waitForExistence(timeout: 2))
        XCTAssert(app.tables[searchTableViewIdentifier].cells.count > 0)
        XCTAssert(app.staticTexts["Your search did not have any results."].exists == false)
        
        app.tables[searchTableViewIdentifier].cells.firstMatch.tap()
        XCTAssert(app.staticTexts["Learning Django Web Development"].waitForExistence(timeout: 2))
        XCTAssert(app.buttons["Close"].exists)
        
        app.buttons["Close"].tap()
        XCTAssert(app.searchFields["Search"].waitForExistence(timeout: 2))
        
        app.searchFields["Search"].tap()
        app.searchFields["Search"].clearText()
        XCTAssert(app.tables.count == 0)
        XCTAssert(app.staticTexts["Your search did not have any results."].exists == false)
    }
    
    private func moveToSearchTab() {
        XCTContext.runActivity(named: "Move to Search Tab") { _ in
            app.tabBars.firstMatch.buttons["Search"].tap()
            XCTAssert(app.buttons["Cancel"].waitForExistence(timeout: 2), "Search textfield cancel button missing.")
            XCTAssert(app.keyboards.count > 0, "Keyboard should be shown.")
            XCTAssert(app.searchFields["Search"].waitForExistence(timeout: 2))
        }
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = value as? String else {
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}
