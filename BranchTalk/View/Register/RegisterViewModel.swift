//
//  RegisterViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/5/24.
//

import Foundation
import RxSwift
import RxRelay

final class RegisterViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailHasOneLetter: Observable<String>
        let emailDuplicateTap: Observable<Void>
        let nickValid: Observable<String>
        let phoneValid: Observable<String>
        let passwordValid: Observable<String>
        let checkPasswordValid: Observable<String>
//        let registerActivate: Observable<Void>
        let registerTap: Observable<Void>
    }
    
    struct Output {
        let emailValid: BehaviorRelay<Bool>
        let emailDuplicateTap: BehaviorRelay<Bool>
        let registerActivate: Observable<Bool>
        let registerTap: Observable<Void>
        //        let errorText: PublishRelay<String>
        //        let nickValid: BehaviorRelay<Bool>
        //        let passwordValid: BehaviorRelay<Bool>
        //        let checkDuplicatePassword: BehaviorRelay<Bool>
        //        let emailDuplicate: PublishRelay<Void>
        //        let registerTap: BehaviorRelay<Bool>
    }
    
    let emailVerification = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        let emailDuplicateActive = BehaviorRelay<Bool>(value: false)
        let checkEmailValidate = BehaviorRelay<Bool>(value: false)
        let emailValid = input.emailHasOneLetter.filter { ValidationCheck().isValidEmail($0) == true }
        let emailValidcheck = input.emailHasOneLetter.map {
            ValidationCheck().isValidEmail($0) }
        
        let nickValid = BehaviorRelay<Bool>(value: false)
        let phoneValid = BehaviorRelay<Bool>(value: false)
        let passwordValid = BehaviorRelay<Bool>(value: false)
        let checkPasswordValid = BehaviorRelay<Bool>(value: false)
        
        let passwordSubject = BehaviorSubject<String>(value: "")
        let checkPasswordSubject = BehaviorSubject<String>(value: "")
        
        let registerActivate = BehaviorRelay<Bool>(value: false)
        
        // 이메일이 한글자이상 있으면 버튼 활성화
        input.emailHasOneLetter
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                emailDuplicateActive.accept(value)
            }
            .disposed(by: disposeBag)
        
        emailValidcheck.bind(with: self) { owner, bool in
            owner.emailVerification.accept(bool ? true : false)
        }
        .disposed(by: disposeBag)
        
        if emailVerification.value == true {
            //유효성 검사를 통과한 이메일 중복검사
            input.emailDuplicateTap
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(emailValid)
                .flatMapLatest { email in
                    NetworkManager.shared.requestEmailDuplicate(api: Router.emailValidate(email: email))
                }
                .subscribe(with: self,
                           onNext: {
                    owner, response in
                    owner.emailVerification.accept(true)
                    checkEmailValidate.accept(true)
                },
                           onError: { owner, error in
                    checkEmailValidate.accept(false)
                })
                .disposed(by: disposeBag)
        }
        // 아무값이나 있을 때 중복확인 버튼을 눌렀을 때
        input.emailDuplicateTap
            .bind(with: self) { owner, _ in
                if owner.emailVerification.value == false {
                    checkEmailValidate.accept(false)
                } else {
                    checkEmailValidate.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.nickValid
            .map { $0.count >= 1 && $0.count <= 30 }
            .bind(with: self) { owner, bool in
                nickValid.accept(bool)
            }
            .disposed(by: disposeBag)
        
        input.phoneValid
            .map { ValidationCheck().validatePhoneNumber($0) }
            .bind(with: self) { owner, bool in
                phoneValid.accept(bool)
            }
            .disposed(by: disposeBag)
        
        input.passwordValid
            .map { ValidationCheck().validatePassword($0) }
            .bind(with: self) { owner, bool in
                passwordValid.accept(bool)
                print(passwordValid.value)
            }
            .disposed(by: disposeBag)
        
        // 비밀번호 확인 로직
        Observable.combineLatest(
            input.passwordValid,
            input.checkPasswordValid
        )
        .bind(with: self) { owner, value in
            checkPasswordValid.accept((value.0 == value.1) ? true : false)
        }
        .disposed(by: disposeBag)
            
        //버튼 활성화 로직
        let joinvalid = Observable.combineLatest(
            input.emailHasOneLetter,
            input.nickValid,
            input.phoneValid,
            input.passwordValid,
            input.checkPasswordValid
        ) { (email, nick, phone, pw, chpw) in
            if !email.isEmpty && !nick.isEmpty && !phone.isEmpty && !pw.isEmpty && !chpw.isEmpty {
                return true
            } else {
                return false
            }
        }
        
            
//        input.registerTap
    
            
        
            
            
            
        
        return Output(emailValid: emailDuplicateActive, emailDuplicateTap: checkEmailValidate, registerActivate: joinvalid, registerTap: input.registerTap)
    }
}
