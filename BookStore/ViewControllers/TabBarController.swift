//
//  TabBarController.swift
//  BookStore
//
//  Created by Soojin Ro on 16/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        _ = (viewController as? SearchViewController)?.focusSearchBar()
    }
}
