//
//  JTabBarController.swift
//  DUCE
//
//  Created by Devang on 1/29/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class JTabBarController: UITabBarController {
    var tabBarView : CustomTabBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        _appDelegator.tabBarLoaded?(true)
    }
}

extension JTabBarController {
    
    func prepareUI() {
        tabBar.isHidden = true
        addCustomTabBar()
    }
    
    func addCustomTabBar() {
        tabBarView = CustomTabBarView.getView()
        self.selectedIndex = 0
        tabBarView.getSelectedIndex { idx in
            self.selectedIndex = idx
        }
        view.addSubview(tabBarView)
    }
    
}
