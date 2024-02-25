//
//  NetworkModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation

struct LoginResult: Decodable {
    let userID: Int
    let email, nickname, createdAt: String
    let profileImage, vendor, phone: String?
    let token: Tokens
    
    enum CodingKeys: String, CodingKey {
        case token
        case nickname, vendor, createdAt, email, profileImage, phone
        case userID = "user_id"
    }
}

struct Tokens: Decodable {
    let accessToken, refreshToken: String
}

struct makeWorkSpaceResult: Decodable {
    let workspaceID, ownerID: Int
    let name, thumbnail,createdAt: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name, description, thumbnail, createdAt
        case workspaceID = "workspace_id"
        case ownerID = "owner_id"
    }
}

struct TokenResponse: Decodable {
    let accessToken: String
}


struct GetChannel: Decodable, Hashable {
    let workspaceID, channelID, ownerID, `private`: Int
    let name, createdAt: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case ownerID = "owner_id"
        case name, description, createdAt
        case `private`
    }
}


