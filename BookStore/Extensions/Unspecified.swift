//
//  Unspecified.swift
//  BookStore
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

func unspecified<T>() -> T {
    preconditionFailure("\(T.self) is not specified")
}
