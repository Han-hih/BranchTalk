//
//  CustomTitle2Label.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

class CustomTitle2Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    private func setLabel() {
        font = Font.title2Bold()
        textColor = Colors.BrandBlack.CutsomColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

