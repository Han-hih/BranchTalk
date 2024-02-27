//
//  SocketIOManager.swift
//  BranchTalk
//
//  Created by 황인호 on 2/25/24.
//

import Foundation
import SocketIO
import RxSwift

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var isOpen = false
    
    let message = PublishSubject<ChannelChatting>()
    
    //소켓 초기화
    override init() {
        super.init()
        
        self.manager = SocketManager(socketURL: URL(string: APIKey.baseURL)!, config: [.log(true), .compress])
        socket = self.manager.defaultSocket
        print("소켓 초기화 완료")
    }
    
    
    // 소켓 연결 메서드
    func connectSocket(channelID: Int) {
        let nameSpace = "/ws-channel-\(channelID)"
        
        socket = manager.socket(forNamespace: nameSpace)
        socket.connect()
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.receiveChatting(dataArray: data)
        }
        
        
        isOpen = true
    }
    
    //dataArray를 받는다.
    func receiveChatting(dataArray: [Any]) {
        socket.on("channel") { dataArray, ack in
            print("CHANNEL RECEIVED", dataArray, ack)
            if let data = dataArray[0] as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: data, options: [])
                    let chatData = try JSONDecoder().decode(ChannelChatting.self, from: data)
                    
                    print("🔥", chatData)
                    self.message.onNext(chatData)
                   
                } catch {
                    print("디코딩에러")
                }
            }
            
        }
        
    }
    
    // 소켓 해제 메서드
    func disconnectSocket() {
        
        socket.disconnect()
        socket.removeAllHandlers()
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        isOpen = false
    }
    
    //채팅을 받는 함수가 필요
    func chatting(completion: @escaping(ChannelChatting) -> Void) {
        socket.on("channel") { data, ack in
            if let data = data[0] as? [String: Any] {
                print("~~~~~~~~~~~~~~~~~~~~", data)
            }
        }
    }
}
