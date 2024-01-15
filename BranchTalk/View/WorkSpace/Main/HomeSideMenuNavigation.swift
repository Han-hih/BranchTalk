//
//  HomeSideMenu.swift
//  BranchTalk
//
//  Created by 황인호 on 1/13/24.
//

import UIKit
import SideMenu

class HomeSideMenuNavigation: SideMenuNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftSide = true
        self.presentationStyle = .menuSlideIn
        self.menuWidth = self.view.frame.width * 0.8
    }
}
