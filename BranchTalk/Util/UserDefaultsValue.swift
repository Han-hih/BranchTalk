//
//  UserDefaults.swift
//  BranchTalk
//
//  Created by 황인호 on 1/27/24.
//

import Foundation

final class UserDefaultsValue {
    
    static let shared = UserDefaultsValue()
    
    var workSpaceID = UserDefaults.standard.integer(forKey: "workSpaceID")
    
}
