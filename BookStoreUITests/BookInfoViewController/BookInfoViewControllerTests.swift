//
//  BookInfoViewControllerTests.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 25/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
import Swifter

private let newBooksPath = "/1.0/new"
private let bookInfoPath = "/1.0/books/9781788476249"
private let tableViewIdentifier = "NewBooksTableView"
private let normalNewBooksJSONFilename = "NewBooksNormal.json"
private let normalBookInfoJSONFilename = "BookInfoNormal.json"

class BookInfoViewControllerTests: XCTestCase {
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

    func testBookInfoBuy() {
        do {
            let newBooksJSONPath = try TestUtil.path(for: normalNewBooksJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(newBooksJSONPath)
            
            let bookInfoJSONPath = try TestUtil.path(for: normalBookInfoJSONFilename, in: type(of: self))
            server[bookInfoPath] = shareFile(bookInfoJSONPath)
            
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
        app.tables[tableViewIdentifier].cells.firstMatch.tap()
        
        assertSuccessfulResult()
        
        let startCoord = app.staticTexts["Sharan Volin"].coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let targetCoord = app.staticTexts["Sharan Volin"].coordinate(withNormalizedOffset: CGVector(dx: 0, dy: -200))
        startCoord.press(forDuration: 0.01, thenDragTo: targetCoord)
        XCTAssert(app.buttons["Buy from BookStore"].waitForExistence(timeout: 3), "Buy button doesn't exist.")
        
        app.buttons["Buy from BookStore"].tap()
        
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        XCTAssert(safari.wait(for: .runningForeground, timeout: 10), "Safari App Foreground")
    }
    
    func testBookInfoClose() {
        do {
            let newBooksJSONPath = try TestUtil.path(for: normalNewBooksJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(newBooksJSONPath)
            
            let bookInfoJSONPath = try TestUtil.path(for: normalBookInfoJSONFilename, in: type(of: self))
            server[bookInfoPath] = shareFile(bookInfoJSONPath)
            
            try server.start()
            app.launch()
        } catch {
            XCTAssert(false, "Swifter Server failed to start.")
        }
        
        XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
        app.tables[tableViewIdentifier].cells.firstMatch.tap()
        
        assertSuccessfulResult()
        app.buttons["Close"].tap()
        
        XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
    }
    
    func testBookInfoError() {
        do {
            let newBooksJSONPath = try TestUtil.path(for: normalNewBooksJSONFilename, in: type(of: self))
            server[newBooksPath] = shareFile(newBooksJSONPath)

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
        
        XCTAssert(app.alerts.buttons["Retry"].waitForExistence(timeout: 5))
    }
    
    private func assertSuccessfulResult() {
        XCTContext.runActivity(named: "Test Successful Book Info ViewController") { _ in
            XCTAssert(app.staticTexts["Learning C++ by Building Games with Unreal Engine 4, 2nd Edition"].waitForExistence(timeout: 5))
            XCTAssert(app.staticTexts["A beginner's guide to learning 3D game development with C++ and UE4"].exists)
            XCTAssert(app.buttons["Close"].exists)
            XCTAssert(app.activityIndicators.count == 0)
        }
    }
}
