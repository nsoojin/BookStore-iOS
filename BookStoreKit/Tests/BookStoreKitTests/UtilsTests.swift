//
//  UtilsTests.swift
//  BookStoreKitTests
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStoreKit

enum SampleError: Error {
    case sample
}

class UtilsTests: XCTestCase {
    func testDebouncer() {
        let debouncer = Debouncer(label: "debouncer.test", delay: 0.3)
        
        let expectationCancel = expectation(description: "This job should cancel")
        expectationCancel.isInverted = true
        let expectationSuccess = expectation(description: "This job should succeed")
        
        debouncer.schedule {
            expectationCancel.fulfill()
        }
        
        debouncer.schedule {
            expectationSuccess.fulfill()
        }
       
        waitForExpectations(timeout: 0.5)
    }
    
    func testMapThrowSuccess() {
        let hello: Result<String, Error> = .success("Hello")
        
        let transform: (String) throws -> String = {
            return "\($0) World"
        }
        
        let result = hello.mapThrow(transform)
        
        switch result {
        case .success(let value):
            XCTAssertEqual(value, "Hello World")
        case .failure:
            XCTFail("Result MapThrow should succeed")
        }
    }
    
    func testMapThrowFailure() {
        let hello: Result<String, Error> = .success("Hello")
        
        let transform: (String) throws -> String = { _ in
            throw SampleError.sample
        }
        
        let result = hello.mapThrow(transform)
        
        switch result {
        case .success:
            XCTFail("Result MapThrow should fail")
        case .failure(let error):
            XCTAssertTrue((error as? SampleError) == .sample)
        }
    }
    
    func testResultSuccess() {
        let helloWorldSuccess: Result<String, Error> = .success("Hello World")
        
        helloWorldSuccess.success {
            XCTAssertEqual($0, "Hello World")
        }
        
        helloWorldSuccess.catch { _ in
            XCTFail("\(helloWorldSuccess) should not be an error")
        }
    }
    
    func testResultFailure() {
        let helloWorldFailure: Result<String, SampleError> = .failure(.sample)
        
        helloWorldFailure.success { _ in
            XCTFail("\(helloWorldFailure) should not be a success")
        }
        
        helloWorldFailure.catch {
            XCTAssertEqual($0, .sample)
        }
    }
}
