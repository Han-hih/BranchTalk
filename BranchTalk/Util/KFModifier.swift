//
//  KFModifier.swift
//  Re
//
//  Created by 황인호 on 12/14/23.
//

import Foundation
import Kingfisher

struct KFModifier {
    
    static let shared = KFModifier()
    
    let modifier = AnyModifier { request in
        var request = request
        request.setValue(KeyChain.shared.read(key: "access") ?? "", forHTTPHeaderField: "Authorization")
        request.setValue(APIKey.apiKey, forHTTPHeaderField: "SesacKey")
        return request
    }
}
