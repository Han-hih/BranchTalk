//
//  WorkSpaceList.swift
//  BranchTalk
//
//  Created by 황인호 on 1/24/24.
//

import Foundation

struct WorkSpaceList: Decodable {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.workspaceID = try container.decode(Int.self, forKey: .workspaceID)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        let path = try container.decode(String.self, forKey: .thumbnail)
        self.thumbnail = APIKey.baseURL + "/v1" + path
        self.ownerID = try container.decode(Int.self, forKey: .ownerID)
        
        let serverDate = try container.decode(String.self, forKey: .createdAt)
        let date = serverDate.toDate()
        let formattedDate = serverDate.toFormattedString()
        
        self.createdAt = formattedDate ?? ""
    }
}
