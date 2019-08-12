//
//  Debouncer.swift
//  BookStoreKit
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import Foundation

class Debouncer {
    let delay: TimeInterval
    
    func schedule(block: @escaping () -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            self.workItem.cancel()
            
            let newItem = DispatchWorkItem(block: block)
            self.queue.asyncAfter(deadline: .now() + self.delay, execute: newItem)
            self.workItem = newItem
        }
    }
    
    init(label: String, delay: TimeInterval) {
        self.queue = DispatchQueue(label: label)
        self.workItem = DispatchWorkItem(block: {})
        self.delay = delay
    }
    
    private let queue: DispatchQueue
    private var workItem: DispatchWorkItem
}
