//
//  ChannelChattingViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 2/3/24.
//

import Foundation
import RxSwift

class ChannelChattingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let chatTrigger: Observable<Void>
        
    }
    
    struct Output {
        let chatList: PublishSubject<[ChannelChatting]>
        
    }
    
    func transform(input: Input) -> Output {
        let chatTrigger = PublishSubject<[ChannelChatting]>()
        
        input.chatTrigger
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: [ChannelChatting].self,
                    api: .getChannelChatting(
                        cursor_date: " ",
                        name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                        id: UserDefaults.standard.integer(forKey: "channelID")
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("채팅리스트----------", response)
                    chatTrigger.onNext(response)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(chatList: chatTrigger)
    }
}
