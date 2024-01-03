//
//  CustomRegisterTextField.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

class CustomRegisterTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextField()
    }
    
    private func setTextField() {
        font = Font.body()
        textColor = Colors.BrandBlack.CutsomColor
        setPlaceholder(color: Colors.BrandGray.CutsomColor, font: Font.body())
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = Colors.BackgroundSecondary.CutsomColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextField {
    func setPlaceholder(color: UIColor, font: UIFont) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color,
                                                                                .font: font])
    }
}


