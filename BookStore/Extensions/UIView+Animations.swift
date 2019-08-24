//
//  UIView+Animations.swift
//  BookStore
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import UIKit

private let durationFadeAnimation: TimeInterval = 0.2

extension UIView {
    func animateFadeIn(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: durationFadeAnimation, delay: 0, options: [.beginFromCurrentState], animations: {
            self.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }

    func animateFadeOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: durationFadeAnimation, delay: 0, options: [.beginFromCurrentState], animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }

    static func animateFadeOut(_ views: [UIView?], completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: durationFadeAnimation, animations: {
            views.forEach { $0?.alpha = 0 }
        }, completion: { _ in
            completion?()
        })
    }

    static func animateFadeIn(_ views: [UIView?], completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: durationFadeAnimation, animations: {
            views.forEach { $0?.alpha = 1 }
        }, completion: { _ in
            completion?()
        })
    }
}
