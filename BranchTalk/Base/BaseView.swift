//
//  BaseView.swift
//  BranchTalk
//
//  Created by 황인호 on 2/28/24.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
            setConstraints()
        }
  
        func configure() {
            backgroundColor = Colors.BackgroundSecondary.CutsomColor
        }
        
        func setConstraints() {
            
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
