//
//  NetworkModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation

struct KakaoResult: Decodable {
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
