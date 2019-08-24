//
//  Result+Extensions.swift
//  BookStore
//
//  Created by Soojin Ro on 13/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

enum ResultError: Error {
    case nilValue
}

extension Result {
    func mapThrow<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        do {
            return .success(try transform(try get()))
        } catch {
            return .failure(error)
        }
    }
    
    @discardableResult
    func success(_ successHandler: (Success) -> Void) -> Result<Success, Failure> {
        if case .success(let value) = self {
            successHandler(value)
        }
        
        return self
    }
    
    @discardableResult
    func `catch`(_ failureHandler: (Failure) -> Void) -> Result<Success, Failure> {
        if case .failure(let error) = self {
            failureHandler(error)
        }
        
        return self
    }
}
