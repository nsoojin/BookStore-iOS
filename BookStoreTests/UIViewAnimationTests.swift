//
//  UIViewAnimationTests.swift
//  BookStoreTests
//
//  Created by Soojin Ro on 24/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import XCTest
@testable import BookStore

class UIViewAnimationTests: XCTestCase {

    func testAnimateFadeIn() {
        let expectationFadeIn = expectation(description: "UIView Animate Fade In")
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        view.alpha = 0
        
        view.animateFadeIn {
            XCTAssertTrue(view.alpha == 1)
            expectationFadeIn.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testAnimateFadeOut() {
        let expectationFadeIn = expectation(description: "UIView Animate Fade Out")
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        
        view.animateFadeOut {
            XCTAssertTrue(view.alpha == 0)
            expectationFadeIn.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testAnimateFadeInViews() {
        let expectationFadeIn = expectation(description: "UIView Animate Fade In Views")
        
        let views = (0..<10).map { _ -> UIView in
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
            view.alpha = 0
            return view
        }
        
        UIView.animateFadeIn(views) {
            views.forEach({
                XCTAssertTrue($0.alpha == 1, "UIView alpha should be 1, but it is \($0.alpha)")
            })
            
            expectationFadeIn.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testAnimateFadeOutViews() {
        let expectationFadeIn = expectation(description: "UIView Animate Fade Out Views")
        
        let views = (0..<10).map { _ -> UIView in
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
            view.alpha = 1
            return view
        }
        
        UIView.animateFadeOut(views) {
            views.forEach({
                XCTAssertTrue($0.alpha == 0, "UIView alpha should be 0, but it is \($0.alpha)")
            })
            
            expectationFadeIn.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
