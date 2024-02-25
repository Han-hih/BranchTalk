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
    private var lastDay: Date?
    
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
                .do(onNext: { [unowned self] _ in
                    if realm.isEmpty { lastDay = "".toDate() }
                    else {
                        chatList = realm.objects(ChatDetailTable.self)
                        let array: [ChatDetailTable] = chatList.map { $0 }
                        chatTrigger.onNext(array)
                        lastDay = array.last?.time ?? Date()
                        print("🙏", "먼저 실행되어야함")
                    }
                })
                .flatMapLatest { _ in
                    NetworkManager.shared.requestSingle(
                        type: [ChannelChatting].self,
                        api: .getChannelChatting(
                            cursor_date: self.lastDay?.toString(),
                            name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                            id: UserDefaults.standard.integer(forKey: "workSpaceID")
                        )
                    )
                }
                .bind(with: self, onNext: { owner, result in
                    switch result {
                    case .success(let response):
                        if response.isEmpty {
                            print("🔥", "새로운 채팅없음", response)
                        } else {
                            print("👍", "새로운 채팅 있음", response)
                            for i in 0..<response.count {
                                let chatDetail = ChatDetailTable(
                                    chatID: response[i].chatID,
                                    chatText: response[i].content,
                                    time: response[i].createdAt.toDate() ?? Date(),
                                    chatFiles: owner.arrayToList(
                                        response[i].files
                                    )
                                )
                                
                                let chatUser = UserInfo(
                                    ownerID: response[i].user.userID,
                                    userName: response[i].user.nickname,
                                    userImage: response[i].user.profileImage 
                                )
                                
                                let channelInfo = ChannelInfoDetail(
                                    channelID: response[i].channelID,
                                    channelName: response[i].channelName
                                )
                                
                                chatDetail.user = chatUser
                                chatDetail.info = channelInfo
                                
                                //뭔가 좋은 로직은 아니지만 일단 넘어가고 업데이트
                                owner.chatListRepository.createItem(chatDetail)
                                
                                appendSendMessage.onNext(chatDetail)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
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
                    type: ChannelChatting.self,
                    api: .postChatting(
                        name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                        id: UserDefaults.standard.integer(forKey: "workSpaceID"),
                        ChatRequestBody(content: text, files: images)
                    )
                )
            }
            .bind(with: self, onNext: { [self] owner, result in
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
    
    private func latestChatting() {
        print("💪", "나중에 실행되어야함", lastDay)
        NetworkManager.shared.request(type: [ChannelChatting].self,
                                      api: .getChannelChatting(cursor_date: lastDay?.toString(),
                                                               name: UserDefaults.standard.string(forKey: "channelName") ?? "",
                                                               id: UserDefaults.standard.integer(forKey: "workSpaceID"))) { result in
            switch result {
            case .success(let response):
                print("🔥", response)
                if response.isEmpty {
                    print("새로 온 채팅이 없음")
                } else {
                    
                }
            case .failure(let error):
                print("💀", error)
            }
        }
    }
}
