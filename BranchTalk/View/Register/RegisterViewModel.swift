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
        let nonValidEmailDuplicateTap: Observable<Void>
        let nickValid: Observable<String>
        let phoneValid: Observable<String>
        let passwordValid: Observable<String>
        let checkPasswordValid: Observable<String>
        let registerTap: Observable<Void>
    }
    
    struct Output {
        let emailValid: BehaviorRelay<Bool>
        let emailDuplicateTap: BehaviorRelay<String>
        let nonValidEmailDuplicateTap: BehaviorRelay<Bool>
        let emailVerification: BehaviorRelay<Bool>
        let registerActivate: Observable<Bool>
        let registerTap: Observable<Void>
        let falseValue: PublishRelay<[Bool]>
        
        let emailToast: PublishRelay<Bool>
        let nickToast: PublishRelay<Bool>
        let phoneToast: PublishRelay<Bool>
        let pwToast: PublishRelay<Bool>
        let chpwToast: PublishRelay<Bool>
    }
    
    let emailVerification = BehaviorRelay<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        let emailDuplicateActive = BehaviorRelay<Bool>(value: false)
        let checkEmailValidate = BehaviorRelay<String>(value: "")
        let emailValid = input.emailHasOneLetter.filter { ValidationCheck().isValidEmail($0) == true }
        let emailValidcheck = input.emailHasOneLetter.map {
            ValidationCheck().isValidEmail($0) }
        let nonValidEmailDuplicateTap = BehaviorRelay<Bool>(value: false)
        
        let nickValid = BehaviorRelay<Bool>(value: false)
        let phoneValid = BehaviorRelay<Bool>(value: false)
        let passwordValid = BehaviorRelay<Bool>(value: false)
        let checkPasswordValid = BehaviorRelay<Bool>(value: false)
        
        let emailToast = PublishRelay<Bool>()
        let nickToast = PublishRelay<Bool>()
        let phoneToast = PublishRelay<Bool>()
        let pwToast = PublishRelay<Bool>()
        let chpwToast = PublishRelay<Bool>()
        
        
        let registerTap = PublishRelay<[Bool]>()
        
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
        
        // 아무값이나 있을 때 중복확인 버튼을 눌렀을 때
            input.emailDuplicateTap
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(emailValid)
                .flatMapLatest { email in
                        NetworkManager.shared.requestEmailDuplicate(api: Router.emailValidate(email: email))
                }
                .bind(with: self, onNext: { owner, result in
                    switch result {
                    case .success(_):
                        if owner.emailVerification.value {
                            checkEmailValidate.accept("사용가능")
                        }
                    case .failure(let error):
                        if error == .duplicate {
                            if owner.emailVerification.value {
                                checkEmailValidate.accept("중복")
                            }
                        }
                    }
                })
                .disposed(by: disposeBag)
        
        input.emailDuplicateTap
            .bind(with: self, onNext: { owner, _ in
                if owner.emailVerification.value == false {
                    nonValidEmailDuplicateTap.accept(false)
                    owner.emailVerification.accept(false)
                    
                } else {
                    nonValidEmailDuplicateTap.accept(true)
                    owner.emailVerification.accept(true)
                }
            })
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
                print(bool)
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
            if !value.0.isEmpty && !value.1.isEmpty  && passwordValid.value == true {
                checkPasswordValid.accept((value.0 == value.1) ? true : false)
            }
        }
        .disposed(by: disposeBag)
        
        //버튼 활성화 로직
        let joinvalid = Observable.combineLatest(
            input.emailHasOneLetter,
            input.nickValid,
            input.passwordValid,
            input.checkPasswordValid
        ) { (email, nick, pw, chpw) in
            if !email.isEmpty && !nick.isEmpty && !pw.isEmpty && !chpw.isEmpty {
                return true
            } else {
                return false
            }
        }
        
        input.registerTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(
                Observable.combineLatest(
                    emailVerification,
                    nickValid,
                    phoneValid,
                    passwordValid,
                    checkPasswordValid
                )
            )
            .bind(with: self) { owner, value in
                let falseArray = [value.0, value.1, value.2, value.3, value.4]
                
                registerTap.accept(falseArray)
                
                if value.0 == false {
                    emailToast.accept(true)
                }
                
                if value.1 == false {
                    nickToast.accept(true)
                }
                
                if value.2 == false {
                    phoneToast.accept(true)
                }
                
                if value.3 == false {
                    pwToast.accept(true)
                }
                
                if value.4 == false {
                    chpwToast.accept(true)
                }
                
            }
            .disposed(by: disposeBag)
        
        input.registerTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(
                Observable.combineLatest(
                    input.emailHasOneLetter,
                    input.nickValid,
                    input.phoneValid,
                    input.passwordValid,
                    input.checkPasswordValid
                )
            )
            .flatMapLatest { email, nick, phone, pw, chpw in
                NetworkManager.shared.requestSingle(type: LoginResult.self, api: Router.register(email: email, password: pw, nickname: nick, phone: phone, deviceToken: ""))
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    KeyChain.shared.keyChainSetting(id: response.userID, access: response.token.accessToken, refresh: response.token.refreshToken)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            emailValid: emailDuplicateActive,
            emailDuplicateTap: checkEmailValidate,
            nonValidEmailDuplicateTap: nonValidEmailDuplicateTap,
            emailVerification: emailVerification,
            registerActivate: joinvalid,
            registerTap: input.registerTap,
            falseValue: registerTap,
            emailToast: emailToast,
            nickToast: nickToast,
            phoneToast: phoneToast,
            pwToast: pwToast,
            chpwToast: chpwToast
        )
    }
}
