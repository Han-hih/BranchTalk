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
        
    }
    
    struct Output {
        let nameTextFieldInput: BehaviorRelay<Bool>
        
    }
    
    func transform(input: Input) -> Output {
        let completeButtonActivate = BehaviorRelay<Bool>(value: false)
        
        
        input.nameTextFieldInput
            .map { $0.count > 0 && $0.count <= 30 }
            .bind(with: self) { owner, value in
                completeButtonActivate.accept(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(nameTextFieldInput: completeButtonActivate)
    }
    
}
