//
//  UnwrapTests.swift
//  BookStoreTests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStore

enum UnwrapError: Error {
    case test1
    case test2
}

class UnwrapTests: XCTestCase {

    func testOptionalUnwrap() {
        let optInt1: Int? = 5
        let optInt2: Int? = nil
        
        do {
            let unwrapped = try optInt1.unwrap()
            XCTAssertEqual(unwrapped, 5)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let _ = try optInt2.unwrap()
            XCTAssert(false)
        } catch {
            XCTAssertTrue((error as? ResultError) == .nilValue)
        }
        
        do {
            let _ = try optInt2.unwrap(errorIfNil: UnwrapError.test1)
            XCTAssert(false)
        } catch {
            XCTAssertTrue((error as? UnwrapError) == .test1)
        }
    }
    
    func testResultUnwrap() {
        let result1 = Result { 1 }
        let result2 = Result { throw UnwrapError.test1 }
        
        do {
            let value = try result1.unwrap()
            XCTAssertEqual(value, 1)
        } catch {
            XCTAssert(false)
        }
        
        do {
            let _ = try result2.unwrap()
            XCTAssert(false)
        } catch {
            XCTAssertTrue((error as? UnwrapError) == .test1)
        }
        
        do {
            let _ = try result2.unwrap(errorIfNil: UnwrapError.test2)
            XCTAssert(false)
        } catch {
            XCTAssertTrue((error as? UnwrapError) == .test2)
        }
    }
}
