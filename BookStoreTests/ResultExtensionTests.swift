//
//  ResultExtensionTests.swift
//  BookStoreTests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStore

enum ResultTestError: Error {
    case test1
    case test2
}

class ResultExtensionTests: XCTestCase {
    
    func testResultMapThrow() {
        let transform: (Int) throws -> String = {
            if $0 == 5 {
                return "\($0*2)"
            } else {
                throw ResultTestError.test2
            }
        }
        
        let successResult1: Result<Int, ResultTestError> = .success(5)
        let successResult2: Result<Int, ResultTestError> = .success(1)
        let failureResult: Result<Int, ResultTestError> = .failure(ResultTestError.test1)
        
        let result1 = successResult1.mapThrow(transform)
        let result2 = successResult2.mapThrow(transform)
        let result3 = failureResult.mapThrow(transform)
        
        switch result1 {
        case .success(let value):
            XCTAssertEqual(value, "10")
        case .failure:
            XCTAssert(false)
        }
        
        switch result2 {
        case .success:
            XCTAssert(false)
        case .failure(let error):
            XCTAssertTrue((error as? ResultTestError) == .test2)
        }
        
        switch result3 {
        case .success:
            XCTAssert(false)
        case .failure(let error):
            XCTAssertTrue((error as? ResultTestError) == .test1)
        }
    }

    func testSuccess() {
        let result = Result { 1 }

        result.success {
            XCTAssertEqual($0, 1)
        }.catch { _ in
            XCTAssert(false)
        }
    }
    
    func testCatch() {
        let result = Result { throw ResultTestError.test1 }
        
        result.success { _ in
            XCTAssert(false)
        }.catch {
            XCTAssertTrue(($0 as? ResultTestError) == .test1)
        }
    }
}
