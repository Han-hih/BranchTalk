//
//  EmailLoginViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 2/25/24.
//

import Foundation
import RxSwift
import RxRelay

class EmailLoginViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    func emailLogin(email: String, pw: String, completion: @escaping (LoginResult) -> Void) {
        NetworkManager.shared.request(
            type: LoginResult.self,
            api: .emailLogin(
                email: email,
                pw: pw,
                deviceToken: ""
            )) { result in
                switch result {
                case .success(let response):
                    KeyChain.shared.keyChainSetting(
                        id: response.userID,
                        access: response.token.accessToken,
                        refresh: response.token.refreshToken
                    )
                    completion(response)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getWorkSpaceList() {
        NetworkManager.shared.request(type: [WorkSpaceList].self, api: Router.getWorkSpaceList) { result in
            switch result {
            case .success(let response):
                print(response.count)
                if response.count > 0 {
                    ViewMove.shared.goHomeInitialView()
                } else {
                    ViewMove.shared.goStartWorkSpaceView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    struct Input {
        let loginButtonTapped: Observable<Void>
        let emailInput: Observable<String>
        let passInput: Observable<String>
    }
    
    struct Output {
        let emailTextFieldInput: BehaviorRelay<Bool>
        let createButtonTapped: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let completeButtonActivate = BehaviorRelay<Bool>(value: false)
        let completeButtonTapped = PublishRelay<Bool>()
        
        Observable.combineLatest(
            input.emailInput,
            input.passInput
        )
        .map { $0.0.count > 0 && $0.1.count > 0}
        .bind(with: self) { owner, bool in
            completeButtonActivate.accept(bool)
        }
        .disposed(by: disposeBag)
        
 
        
        
        input.loginButtonTapped
            .withLatestFrom(Observable.combineLatest(input.emailInput, input.passInput))
            .flatMapLatest { (email, pw) in
                NetworkManager.shared.requestSingle(
                    type: LoginResult.self,
                    api: .emailLogin(
                        email: email,
                        pw: pw,
                        deviceToken: ""
                    )
                )
            }
            .subscribe(with: self, onNext: { owner, value in
                switch value {
                case .success(let response):
                    print("😁", response)
                    
//                    completeButtonTapped.accept(true)
                    
                case .failure(let error):
                    print("👍", error)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            emailTextFieldInput: completeButtonActivate,
            createButtonTapped: input.loginButtonTapped
        )
    }
}
