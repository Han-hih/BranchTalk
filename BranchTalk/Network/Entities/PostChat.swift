//
//  PostChat.swift
//  BranchTalk
//
//  Created by 황인호 on 2/18/24.
//

import UIKit

struct PostChat: Decodable {
    let channelID: Int
    let channelName: String
    let chatID: Int
    let content: String?
    let createdAt: String
    let files: [String?]
    let user: PostUser
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
}

struct PostUser: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
