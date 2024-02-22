//
//  ChannelChattingViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 2/3/24.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift

class ChannelChattingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private let chatListRepository = ChatListRepository.shared
    
    private let realm = try! Realm()
    private var chatList: Results<ChatDetailTable>!
    
    private var chatImageArray = [String]()
    private var chatImageRealmList = List<String>()
    private var userRealmList = UserInfo()
    private var channelRealmList = ChannelInfoDetail()
    
    
    struct Input {
        let chatTrigger: Observable<Void>
        let contentInputValid: Observable<String>
        let imageInputValid: Observable<Int>
        let chatImage: Observable<[Data]>
        let sendMessage: Observable<Void>
    }
    
    struct Output {
        let chatList: BehaviorSubject<[ChatDetailTable]>
        let appendChatList: BehaviorSubject<ChatDetailTable>
        let chatInputValid: BehaviorRelay<Bool>
        let sendMessage: PublishSubject<PostChat>
    }
    
    func transform(input: Input) -> Output {
        let chatTrigger = BehaviorSubject<[ChatDetailTable]>(value: [])
        let chatInputValid = BehaviorRelay<Bool>(value: false)
        let sendMessage = PublishSubject<PostChat>()
        let appendSendMessage = BehaviorSubject<ChatDetailTable>(value: ChatDetailTable())
        
        input.chatTrigger
            .bind(with: self) { owner, _ in
                owner.chatList = owner.realm.objects(ChatDetailTable.self)
                let array: [ChatDetailTable] = owner.chatList.map { $0 }
                chatTrigger.onNext(array)
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
            .bind(with: self,
                  onNext: {
                [self] owner,
                result in
                switch result {
                case .success(let response):
                    print(response)
                    
                    let chatDetail = ChatDetailTable(
                        chatID: response.chatID,
                        chatText: response.content,
                        time: response.createdAt.toDate() ?? Date(),
                        chatFiles: arrayToList(
                            response.files
                        )
                    )
                    
                    let chatUser = UserInfo(
                        ownerID: response.user.userID,
                        userName: response.user.nickname,
                        userImage: response.user.profileImage ?? ""
                    )
                    
                    let channelInfo = ChannelInfoDetail(
                        channelID: response.channelID,
                        channelName: response.channelName
                    )
                    
                    chatDetail.user = chatUser
                    chatDetail.info = channelInfo
                    
                    //뭔가 좋은 로직은 아니지만 일단 넘어가고 업데이트
                    chatListRepository.createItem(chatDetail)
                   
                    appendSendMessage.onNext(chatDetail)
                    
                    
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            chatList: chatTrigger,
            appendChatList: appendSendMessage,
            chatInputValid: chatInputValid,
            sendMessage: sendMessage
        )
    }
    
    private func arrayToList(_ file: [String]) -> List<String> {
        chatImageArray = file
        for files in chatImageArray {
            chatImageRealmList.append(files)
        }
        return chatImageRealmList
    }
    
//    private func checkUserID(_ id: Int) -> Bool {
//        if realm.objects(UserInfo.self).contains(where: { userInfo in
//            userInfo.ownerID != id
//        }) {
//            return true
//        } else { return false }
//    }
//    
//    private func checkChannelID(_ id: Int) -> Bool {
//        if realm.objects(ChannelInfoDetail.self).contains(where: { channelInfoDetail in
//            channelInfoDetail.channelID != id
//        }) {
//            return true
//        } else {
//            return false
//        }
//    }
    
//    private func realmWrite(_ object: Object) {
//        try! realm.write {
//            realm.add(object)
//            print("렘에 저장됨")
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//        }
//    }
}
