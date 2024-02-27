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
import SocketIO

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
    
    private let socketManager = SocketIOManager.shared
    
    var socket: SocketIOClient!
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
        let sendMessage: PublishSubject<[ChatDetailTable]>
    }
    
    func transform(input: Input) -> Output {
        let chatTrigger = BehaviorSubject<[ChatDetailTable]>(value: [])
        let chatInputValid = BehaviorRelay<Bool>(value: false)
        let sendMessage = PublishSubject<[ChatDetailTable]>()
        let appendSendMessage = BehaviorSubject<ChatDetailTable>(value: ChatDetailTable())
        let receiveMessage = BehaviorSubject<ChatDetailTable>(value: ChatDetailTable())
        
        //소켓에서 채팅 받아오기
        socketManager.message
            .bind(with: self) { owner, value in
                print("실행 되나")
                let chatDetail = ChatDetailTable(
                    chatID: value.chatID,
                    chatText: value.content,
                    time: value.createdAt.toDate() ?? Date(),
                    chatFiles: owner.arrayToList(
                        value.files
                    )
                )
                
                let chatUser = UserInfo(
                    ownerID: value.user.userID,
                    userName: value.user.nickname,
                    userImage: value.user.profileImage
                )
                
                let channelInfo = ChannelInfoDetail(
                    channelID: value.channelID,
                    channelName: value.channelName
                )
                
                chatDetail.user = chatUser
                chatDetail.info = channelInfo
                
                owner.chatListRepository.createItem(chatDetail)
                receiveMessage.onNext(chatDetail)
            }
            .disposed(by: disposeBag)
        
        //처음 화면 들어왔을 때
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
                        for newChat in response {
                            let chatDetail = ChatDetailTable(
                                chatID: newChat.chatID,
                                chatText: newChat.content,
                                time: newChat.createdAt.toDate() ?? Date(),
                                chatFiles: owner.arrayToList(newChat.files)
                            )
                            
                            let chatUser = UserInfo(
                                ownerID: newChat.user.userID,
                                userName: newChat.user.nickname,
                                userImage: newChat.user.profileImage
                            )
                            
                            let channelInfo = ChannelInfoDetail(
                                channelID: newChat.channelID,
                                channelName: newChat.channelName
                            )
                            
                            chatDetail.user = chatUser
                            chatDetail.info = channelInfo
                            
                            owner.chatImageRealmList.removeAll()
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
                        userImage: response.user.profileImage
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
}
