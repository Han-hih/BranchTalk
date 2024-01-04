//
//  GreenCustonButton.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

class GreenCustonButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    private func setButton() {
        backgroundColor = Colors.BrandGreen.CutsomColor
        clipsToBounds = true
        layer.cornerRadius = 8
        setTitleColor(Colors.BrandWhite.CutsomColor, for: .normal)
        titleLabel?.font = Font.title2Bold()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GrayCustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
    
    private func setButton() {
        backgroundColor = Colors.BrandInactive.CutsomColor
        clipsToBounds = true
        layer.cornerRadius = 8
        setTitleColor(Colors.BrandWhite.CutsomColor, for: .normal)
        titleLabel?.font = Font.title2Bold()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
