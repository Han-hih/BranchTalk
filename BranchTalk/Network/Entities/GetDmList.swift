//
//  GetDMList.swift
//  BranchTalk
//
//  Created by 황인호 on 1/24/24.
//

import Foundation

struct GetDmList: Decodable, Hashable {
    let workspaceID, roomID: Int
    let createdAt: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt, user
    }
    
}

struct User: Decodable, Hashable {
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
        self.nickname = try container.decode(String.self, forKey: .email)
        let path = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.profileImage = APIKey.baseURL + "/v1" + (path ?? "")
    }
    
}
