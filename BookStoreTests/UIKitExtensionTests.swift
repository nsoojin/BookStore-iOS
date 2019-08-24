//
//  UIKitExtensionTests.swift
//  BookStoreTests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStore

class UIKitExtensionTests: XCTestCase {
    
    func testOptionalCollectionIsEmpty() {
        let optionalArray1: [Int]? = nil
        let optionalArray2: [Int]? = []
        let optionalArray3: [Int]? = [1, 2, 3]
        
        XCTAssertTrue(optionalArray1.isEmpty)
        XCTAssertTrue(optionalArray2.isEmpty)
        XCTAssertFalse(optionalArray3.isEmpty)
    }
    
    func testAddActions() {
        let alert = UIAlertController()
        
        let actions = (0..<5).map { _ in
            UIAlertAction(title: "hello", style: .default, handler: nil)
        }
        
        alert.addActions(actions)
        XCTAssertTrue(alert.actions.count == 5)
    }
}
