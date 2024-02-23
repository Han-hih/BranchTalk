//
//  ChatListTable.swift
//  BranchTalk
//
//  Created by 황인호 on 2/19/24.
//

import Foundation
import RealmSwift

final class ChatDetailTable: Object {
    @Persisted(primaryKey: true) var chatID: Int
    @Persisted var chatText: String?
    @Persisted var time: Date
    @Persisted var chatFiles: List<String>
    
    @Persisted var user: UserInfo?
    @Persisted var info: ChannelInfoDetail?
    
    convenience init(chatID: Int, chatText: String? = nil, time: Date, chatFiles: List<String>) {
        self.init()
        self.chatID = chatID
        self.chatText = chatText
        self.time = time
        self.chatFiles = chatFiles
    }
}


 class UserInfo: Object {
    @Persisted(primaryKey: true) var ownerID: Int
    @Persisted var userName: String
    @Persisted var userImage: String
    
    @Persisted(originProperty: "user") var assignee: LinkingObjects<ChatDetailTable>
    
     convenience init(ownerID: Int, userName: String, userImage: String) {
         self.init()
         self.ownerID = ownerID
         self.userName = userName
         self.userImage = userImage
         
     }

}

 class ChannelInfoDetail: Object {
    @Persisted(primaryKey: true) var channelID: Int
    @Persisted var channelName: String
    
    @Persisted(originProperty: "info") var owner: LinkingObjects<ChatDetailTable>
    
    convenience init(channelID: Int, channelName: String) {
        self.init()
        self.channelID = channelID
        self.channelName = channelName
    }
}








//final class ChatListTable: Object {
//    @Persisted(primaryKey: true) var channelId: Int
//    @Persisted var channelName: String
//    @Persisted var chatDetail: List<ChatDetail>
//    
//    convenience init(channelID: Int, channelName: String) {
//        self.init()
//        
//        self.channelId = channelId
//        self.channelName = channelName
//        
//    }
//}
//
//final class ChatDetail: Object {
//    @Persisted(primaryKey: true) var chatID: Int
//    @Persisted var senderName: String
//    @Persisted var senderImage: String?
//    @Persisted var chatText: String?
//    @Persisted var time: Date
//    @Persisted var chatFiles: List<String>
//    
////    @Persisted(originProperty: "List") var chatHistory: LinkingObjects<ChatListTable>
//    
//    convenience init(chatID: Int, senderName: String, senderImage: String? = nil, chatText: String? = nil, time: Date, chatFiles: List<String>) {
//        self.init()
//        self.chatID = chatID
//        self.senderName = senderName
//        self.chatText = chatText
//        self.time = time
//        self.chatFiles = chatFiles
//    }
//}
