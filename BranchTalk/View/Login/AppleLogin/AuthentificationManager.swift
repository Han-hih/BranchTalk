//
//  AuthentificationManager.swift
//  BranchTalk
//
//  Created by 황인호 on 2/27/24.
//

import Foundation
import LocalAuthentication

final class AuthentificationManager {
    
    static let shared = AuthentificationManager()
    
    private init() { }
    
    var selectedPolicy: LAPolicy = .deviceOwnerAuthentication
    
    func auth() {
        
        let context = LAContext()
        context.localizedCancelTitle = "FaceID 인증 취소"
        context.localizedFallbackTitle = "비밀번호로 대신 인증하기"
        
        context.evaluatePolicy(selectedPolicy, localizedReason: "페이스 아이디 인증이 필요합니다") { value, error in
            print(value) //Bool -> CompletionHandler
            
            if let error {
                let code = error._code
                let laError = LAError(LAError.Code(rawValue: code)!)
                print(laError)
            }
        }
    }
    
    //FaceID 쓸 수 있는 상태인지 여부 확인.
    func checkPolicy() -> Bool {
        
        let context = LAContext()
        let policy: LAPolicy = selectedPolicy
        return context.canEvaluatePolicy(policy, error: nil)
        
        
    }
    
    func isFaceIDChanged() -> Bool {
        let context = LAContext()
        context.canEvaluatePolicy(selectedPolicy, error: nil)
        
        let state = context.evaluatedPolicyDomainState // 생체 인증 정보
        
        // 생체 인증 정보를 UserDefaults에 저장
        // 기존 자정된 DomainState와 새롭게 변경된 DomainState를 비교 =>
        print(state)
        return false // 로직 추가
    }
}
