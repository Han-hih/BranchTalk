//
//  MyInfo.swift
//  BranchTalk
//
//  Created by 황인호 on 1/24/24.
//

import Foundation

struct MyInfo: Decodable {
    let userID, sesacCoin: Int
    let email, nickname, createdAt: String
    let profileImage, phone, vendor: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, createdAt, profileImage, phone, vendor, sesacCoin
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        let image = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.profileImage = APIKey.baseURL + "/v1" + (image ?? "")
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.vendor = try container.decodeIfPresent(String.self, forKey: .vendor)
        self.sesacCoin = try container.decode(Int.self, forKey: .sesacCoin)
    }
    
    
}
