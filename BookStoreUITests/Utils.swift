//
//  Utils.swift
//  BookStoreUITests
//
//  Created by Soojin Ro on 25/08/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation
import XCTest

enum TestUtilError: Error {
    case fileNotFound
}

class TestUtil {
    static func path(for fileName: String, in bundleClass: AnyClass) throws -> String {
        if let path = Bundle(for: bundleClass).path(forResource: fileName, ofType: nil) {
            return path
        } else {
            throw TestUtilError.fileNotFound
        }
    }
}
