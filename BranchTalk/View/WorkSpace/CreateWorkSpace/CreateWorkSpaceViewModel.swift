//
//  CreateWorkSpaceViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/8/24.
//

import Foundation
import RxSwift
import RxRelay

class CreateWorkSpaceViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let nameTextFieldInput: Observable<String>
        let createButtonTapped: Observable<Void>
        let nameInput: Observable<String>
        let descInput: Observable<String>
        let image: Observable<Data>
    }
    
    struct Output {
        let nameTextFieldInput: BehaviorRelay<Bool>
        let createButtonTapped: PublishRelay<Bool>
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
            .withLatestFrom(Observable.combineLatest(input.nameInput, input.descInput, input.image))
            .flatMapLatest { (name, desc, image) in
                NetworkManager.shared.requestMultipart(
                    type: makeWorkSpaceResult.self,
                    api: Router.makeWorkSpace(
                        makeWorkSpace(
                            name: name,
                            description: desc,
                            image: image
                        )
                    )
                )
            }
            .subscribe(with: self, onNext: { owner, value in
                switch value {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            nameTextFieldInput: completeButtonActivate,
            createButtonTapped: completeButtonTapped
        )
    }
    
}
