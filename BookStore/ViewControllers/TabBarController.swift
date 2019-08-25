//
//  TabBarController.swift
//  BookStore
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers?.forEach(setBookStore(on:))
        delegate = self
    }
    
    private func setBookStore(on viewController: UIViewController) {
        _setBookStore(on: viewController)
        viewController.children.forEach(_setBookStore(on:))
    }
    
    private func _setBookStore(on viewController: UIViewController) {
        (viewController as? BookStoreView)?.set(ITBookStoreService())
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        _ = (viewController as? SearchViewController)?.focusSearchBar()
    }
}
