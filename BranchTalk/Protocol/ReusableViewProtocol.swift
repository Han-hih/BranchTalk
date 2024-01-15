//
//  ReusableViewProtocol.swift
//  BranchTalk
//
//  Created by 황인호 on 1/15/24.
//

import UIKit

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension UITableViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
