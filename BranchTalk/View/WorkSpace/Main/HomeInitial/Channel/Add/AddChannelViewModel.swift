//
//  AddChannelViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/25/24.
//

import Foundation
import RxSwift
import RxRelay

class AddChannelViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nameTextFieldInput: Observable<String>
        let createButtonTapped: Observable<Void>
        let nameInput: Observable<String>
        let descInput: Observable<String>
    }
    
    struct Output {
        let nameTextFieldInput: BehaviorRelay<Bool>
        let createButtonTapped: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let completeButtonActivate = BehaviorRelay<Bool>(value: false)
        let completeButtonTapped = PublishRelay<Bool>()
        
        
        input.nameTextFieldInput
            .map { $0.count > 0 && $0.count <= 30 }
            .bind(with: self) { owner, value in
                completeButtonActivate.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.createButtonTapped
            .withLatestFrom(Observable.combineLatest(input.nameInput, input.descInput))
            .flatMapLatest { (name, desc) in
                NetworkManager.shared.requestSingle(
                    type: GetChannel.self,
                    api: .createChannel(
                        id: 22,
                        name: name,
                        desc: desc
                    )
                )
            }
            .subscribe(with: self, onNext: { owner, value in
                switch value {
                case .success(let response):
                    completeButtonTapped.accept(true)
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
                
        
        return Output(
            nameTextFieldInput: completeButtonActivate,
            createButtonTapped: input.createButtonTapped
        )
    }
}
