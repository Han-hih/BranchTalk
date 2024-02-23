//
//  MultipartModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/9/24.
//

import Foundation

struct makeWorkSpace: Codable {
    let name: String
    let description: String?
    let image: Data
}

struct ChatRequestBody: Codable {
    let content: String
    let files: [Data]
}

