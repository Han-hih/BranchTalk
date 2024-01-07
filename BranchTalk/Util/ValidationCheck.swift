//
//  RegularExpression.swift
//  BranchTalk
//
//  Created by 황인호 on 1/5/24.
//

import Foundation

final class ValidationCheck {
    // 이메일 정규성 체크(최소 유효성 검증 : @와 .com 포함)
    func isValidEmail(_ input: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: input)
    }
    
    // 핸드폰 번호 정규성 체크(전화번호 유효성 검증 : 01 로 시작하는 10~11자리 숫자)
    func validatePhoneNumber(_ input: String) -> Bool {
        let phoneRegax = "^^01[0-1, 7][0-9]{7,8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegax)
        return phoneTest.evaluate(with: input)
    }
    
    // 비밀번호 정규성 체크(하나 이상의 대문자, 소문자, 숫자, 특수 문자)
    func validatePassword(_ input: String) -> Bool {
        let passwordRegex = "[A-Za-z0-9!_@$%^&+=]{8,}" // 8자리 ~
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: input)
    }
}
