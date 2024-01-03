//
//  Router.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    
    case kakaoLogin(access: String, refresh: String)
    
    private var baseURL: URL {
        guard let url = URL(string: APIKey.baseURL) else { fatalError() }
        return url
    }
    
    private var method: HTTPMethod {
        switch self {
        case .kakaoLogin:
               return .post
        }
    }
    
    private var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .kakaoLogin:
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.apiKey)"]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
        print(request)
        
        return request
    }
    
}
