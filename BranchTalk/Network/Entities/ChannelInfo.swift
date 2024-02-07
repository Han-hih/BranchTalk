//
//  ChannelInfo.swift
//  BranchTalk
//
//  Created by 황인호 on 2/4/24.
//

import Foundation

struct ChannelInfo: Decodable, Hashable {
    let workSpaceID, channelID, ownerID, `private`: Int
    let name, createdAt: String
    let description: String?
    let channelMembers: [ChannelMembers]
    
    enum CodingKeys: String, CodingKey {
        case workSpaceID = "workspace_id"
        case channelID = "channel_id"
        case ownerID = "owner_id"
        case `private`, name, createdAt, description, channelMembers
    }
    
}

struct ChannelMembers: Decodable, Hashable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        
        let path = try container.decode(String?.self, forKey: .profileImage)
        self.profileImage = APIKey.baseURL + "/v1" + (path ?? "")
    }
}

