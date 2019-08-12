//
//  Unwrappable.swift
//  BookStore
//
//  Created by Soojin Ro on 13/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

protocol Unwrappable {
    associatedtype Wrapped
    func unwrap(errorIfNil: Error?) throws -> Wrapped
}

extension Optional: Unwrappable {
    func unwrap(errorIfNil error: Error? = nil) throws -> Wrapped {
        switch self {
        case .some(let unwrapped):
            return unwrapped
        case .none:
            throw error ?? ResultError.nilValue
        }
    }
}

extension Result: Unwrappable {
    func unwrap(errorIfNil: Error? = nil) throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw errorIfNil ?? error
        }
    }
}
