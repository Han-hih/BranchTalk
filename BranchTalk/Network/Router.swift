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
    case emailValidate(email: String)
    
    private var baseURL: URL {
        guard let url = URL(string: APIKey.baseURL) else { fatalError() }
        return url
    }
    
    private var method: HTTPMethod {
        switch self {
        case .kakaoLogin, .emailValidate:
               return .post
        }
    }
    
    private var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .emailValidate:
            return "/v1/users/validation/email"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .kakaoLogin, .emailValidate:
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.apiKey)"]
        }
    }
    
    private var parameters: Parameters {
        switch self {
        case .kakaoLogin(let access, let refresh):
            return ["oauthToken": access,
                    "deviceToken": refresh]
        case .emailValidate(email: let email):
            return ["email": email]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        return request
    }
    
}
