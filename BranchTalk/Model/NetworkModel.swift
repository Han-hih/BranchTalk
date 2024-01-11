//
//  NetworkModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation

struct LoginResult: Decodable {
    let userID: Int
    let email, nickname, vendor, createdAt: String
    let profileImage, phone: String?
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

struct GetWorkSpaceInfo: Decodable {
    let workspaceID: Int
    let description: String?
    let name, thumbnail: String
    let ownerID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt
    }
}

typealias GetWorkSpaceList = [GetWorkSpaceInfo]

