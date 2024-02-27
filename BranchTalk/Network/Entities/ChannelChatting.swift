//
//  ChannelChatting.swift
//  BranchTalk
//
//  Created by 황인호 on 2/2/24.
//

import Foundation

struct ChannelChatting: Codable {
    let channelID: Int
    let channelName, createdAt: String
    let chatID: Int
    let content: String
    let files: [String]
    let user: ChannelUser
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelID = try container.decode(Int.self, forKey: .channelID)
        self.channelName = try container.decode(String.self, forKey: .channelName)
        self.chatID = try container.decode(Int.self, forKey: .chatID)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        
        let paths = try container.decode([String].self, forKey: .files)
        self.files = paths.map { APIKey.baseURL + "/v1" + $0 }
        self.user = try container.decode(ChannelUser.self, forKey: .user)
    }
    
}

struct ChannelUser: Codable {
    let userID: Int
    let email, nickname, profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        let path = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.profileImage = APIKey.baseURL + "/v1" + (path ?? "")
    }
}

