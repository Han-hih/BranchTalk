//
//  HomeInitialViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/16/24.
//

import Foundation
import RxSwift
import RxRelay

class HomeInitialViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let channelTrigger: Observable<Void>
        let dmTrigger: Observable<Void>
    }
    
    struct Output {
        let channelList: PublishSubject<[GetChannel]>
        let dmList: PublishSubject<[GetDmList]>
    }
    
    func transform(input: Input) -> Output {
        let channelObservable = PublishSubject<[GetChannel]>()
        let dmObservable = PublishSubject<[GetDmList]>()
        
         input.channelTrigger
            .debug()
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: [GetChannel].self,
                    api: .getChannelList(
                        id: UserDefaults.standard.integer(forKey: "workSpaceID")
                    )
                )
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    print("채널 리스트ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ", response)
                    channelObservable.onNext(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        input.dmTrigger
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: [GetDmList].self,
                    api: .getDmList(
                        id: UserDefaults.standard.integer(forKey: "workSpaceID")
                    )
                )
            }
            .subscribe(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    print("dm리스트---------", response)
                    dmObservable.onNext(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            channelList: channelObservable,
            dmList: dmObservable
        )
    }
}
