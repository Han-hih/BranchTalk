//
//  CustomTitle1Label.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit

class CustomTitle1Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    private func setLabel() {
        font = Font.title1Bold()
        textColor = Colors.BrandBlack.CutsomColor
        textAlignment = .center
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

class CustomBodyBoldLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    private func setLabel() {
        font = Font.bodyBold()
        textColor = Colors.BrandBlack.CutsomColor
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    private func setLabel() {
        font = Font.body()
        textColor = Colors.TextSecondary.CutsomColor
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
