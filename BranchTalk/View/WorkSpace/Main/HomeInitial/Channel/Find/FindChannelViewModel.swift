//
//  FindChannelViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/28/24.
//

import Foundation
import RxSwift

class FindChannelViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var myChannel = [GetChannel]()
    
    struct Input {
        let channelTrigger: Observable<Void>
    }
    
    struct Output {
        let channelList: PublishSubject<[GetChannel]>
    }
    
    func transform(input: Input) -> Output {
        let channelObservable = PublishSubject<[GetChannel]>()
        
        input.channelTrigger
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: [GetChannel].self,
                    api: .getAllChannel(id: UserDefaults.standard.integer(forKey: "workSpaceID"))
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("전체 채널리스트-------", response)
                    channelObservable.onNext(response)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.channelTrigger
                    .flatMapLatest { _ in
                        NetworkManager.shared.requestSingle(
                            type: [GetChannel].self,
                            api: .getAllMyChannel(id: UserDefaults.standard.integer(forKey: "workSpaceID"))
                        )
                    }
                    .subscribe(with: self) { owner, result in
                        switch result {
                        case .success(let response):
                            print("내가 속한 채널 ------------", response)
                            owner.myChannel = response
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .disposed(by: disposeBag)
        
        return Output(channelList: channelObservable)
    }
}
