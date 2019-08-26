//
//  NewBooksViewControllerTests.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
import Swifter

private let newBooksPath = "/1.0/new"
private let bookInfoPath = "/1.0/books/9781788476249"
private let tableViewIdentifier = "NewBooksTableView"
private let normalResponseJSONFilename = "NewBooksNormal.json"
private let emptyResponseJSONFilename = "NewBooksEmpty.json"

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
            let path = try TestUtil.path(for: normalResponseJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(path)
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        assertTableViewResult()
    }
    
    func testNewBooksEmpty() {
        do {
            let path = try TestUtil.path(for: emptyResponseJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(path)
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.staticTexts["Nothing new 🙃"].waitForExistence(timeout: 3))
    }
    
    func testNewBooksErrorWithRetry() {
        do {
            server[newBooksPath] = { _ in
                return HttpResponse.internalServerError
            }
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.staticTexts["Something went wrong 🤯"].waitForExistence(timeout: 3))
        XCTAssert(app.buttons["Try Again"].exists)
        
        do {
            let path = try TestUtil.path(for: normalResponseJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(path)
        } catch {
            XCTAssert(false, "Couldn't find NewBooksNormal.json file.")
        }
        
        app.buttons["Try Again"].tap()

        assertTableViewResult()
    }
    
    func testNewBookCellTap() {
        do {
            let path = try TestUtil.path(for: normalResponseJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(path)
            server[bookInfoPath] = { _ in
                return HttpResponse.internalServerError
            }
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
        app.tables[tableViewIdentifier].cells.firstMatch.tap()
        
        XCTAssert(app.buttons["Close"].waitForExistence(timeout: 3))
    }
    
    private func assertTableViewResult() {
        XCTContext.runActivity(named: "Test Successful TableView Screen") { _ in
            XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
            XCTAssert(app.tables[tableViewIdentifier].cells.count > 0)
            XCTAssert(app.staticTexts["9781788476249"].exists)
            XCTAssert(app.staticTexts["$44.99"].exists)
        }
    }
}
