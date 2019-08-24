//
//  Foundation+Extensions.swift
//  BookStore
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
