//
//  ChannelChattingViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 2/3/24.
//

import Foundation
import RxSwift
import RxRelay

class ChannelChattingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let chatTrigger: Observable<Void>
        let contentInputValid: Observable<String>
        let imageInputValid: Observable<Int>
        let chatImage: Observable<[Data]>
        let sendMessage: Observable<Void>
    }
    
    struct Output {
        let chatList: PublishSubject<[ChannelChatting]>
        let chatInputValid: BehaviorRelay<Bool>
        let sendMessage: PublishSubject<PostChat>
    }
    
    func transform(input: Input) -> Output {
        let chatTrigger = PublishSubject<[ChannelChatting]>()
        let chatInputValid = BehaviorRelay<Bool>(value: false)
        let sendMessage = PublishSubject<PostChat>()
        
        input.chatTrigger
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: [ChannelChatting].self,
                    api: .getChannelChatting(
                        cursor_date: " ",
                        name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                        id: UserDefaults.standard.integer(forKey: "workSpaceID")
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
        
        Observable.combineLatest(
            input.contentInputValid,
            input.imageInputValid
        )
        .bind(with: self) { owner, value in
            if value.0.count > 0 || value.1 > 0 {
                chatInputValid.accept(true)
            } else {
                chatInputValid.accept(false)
            }
        }
        .disposed(by: disposeBag)
        
        //채팅 Post
        input.sendMessage
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(
                Observable.combineLatest(
                    input.contentInputValid,
                    input.chatImage
                )
            )
            .flatMapLatest { (text, images) in
                NetworkManager.shared.requestMultipart(
                    type: PostChat.self,
                    api: .postChatting(
                        name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                        id: UserDefaults.standard.integer(forKey: "workSpaceID"),
                        ChatRequestBody(content: text, files: images)
                    )
                )
            }
            .debug()
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            chatList: chatTrigger,
            chatInputValid: chatInputValid,
            sendMessage: sendMessage
        )
    }
}
