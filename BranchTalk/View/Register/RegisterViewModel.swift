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
        //        let nickValid: Observable<String>
        //        let passwordValid: Observable<String>
        //        let checkDuplicatePassword: Observable<String>
        
        //        let registerTap: Observable<Void>
    }
    
    struct Output {
        let emailValid: BehaviorRelay<Bool>
        let emailDuplicateTap: BehaviorRelay<Bool>
        //        let errorText: PublishRelay<String>
        //        let nickValid: BehaviorRelay<Bool>
        //        let passwordValid: BehaviorRelay<Bool>
        //        let checkDuplicatePassword: BehaviorRelay<Bool>
        //        let emailDuplicate: PublishRelay<Void>
        //        let registerTap: BehaviorRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        let emailDuplicateActive = BehaviorRelay<Bool>(value: false)
        let checkEmailValidate = BehaviorRelay<Bool>(value: false)
        let emailValid = input.emailHasOneLetter.filter { ValidationCheck().isValidEmail($0) }
        let failEmailValid = input.emailHasOneLetter.filter {
            ValidationCheck().isValidEmail($0) == false }
        
        // 이메일이 한글자이상 있으면 버튼 활성화
        input.emailHasOneLetter
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                emailDuplicateActive.accept(value)
            }
            .disposed(by: disposeBag)
        
        //유효성 검사를 통과한 이메일 중복검사
        input.emailDuplicateTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(emailValid) { _, email in
                return email
            }
            .flatMapLatest { email in
                NetworkManager.shared.requestEmailDuplicate(api: Router.emailValidate(email: email))
            }
            .subscribe(with: self,
                       onNext: {
                owner, response in
                checkEmailValidate.accept(true)
                print(response)
            },
                       onError: { owner, error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        // 아무값이나 있을 때 중복확인 버튼을 눌렀을 때
        input.emailDuplicateTap
            .bind(with: self) { owner, _ in
                checkEmailValidate.accept(false)
            }
            .disposed(by: disposeBag)
        
        
        return Output(emailValid: emailDuplicateActive, emailDuplicateTap: checkEmailValidate)
    }
    
}
