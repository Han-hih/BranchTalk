//
//  Router.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    case kakaoLogin(access: String, refresh: String)
    case emailValidate(email: String)
    case register(email: String, password: String, nickname: String, phone: String?, deviceToken: String?)
    case makeWorkSpace(makeWorkSpace)
    case refresh
    case getWorkSpaceList
    case getMyProfile
    case getChannelList(id: Int)
    
    private var baseURL: URL {
        guard let url = URL(string: APIKey.baseURL) else { fatalError() }
        return url
    }
    
    private var method: HTTPMethod {
        switch self {
        case .kakaoLogin, .emailValidate, .register, .makeWorkSpace:
               return .post
        case .refresh, .getWorkSpaceList, .getMyProfile, .getChannelList:
               return .get
        }
    }
    
    private var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .emailValidate:
            return "/v1/users/validation/email"
        case .register:
            return "/v1/users/join"
        case .makeWorkSpace:
            return "/v1/workspaces"
        case .refresh:
            return "/v1/auth/refresh"
        case .getWorkSpaceList:
            return "/v1/workspaces"
        case .getMyProfile:
            return "v1/users/my"
        case .getChannelList(let id):
            return "v1/workspaces/\(id)/channels"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .kakaoLogin, .emailValidate, .register:
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.apiKey)"]
        case .makeWorkSpace:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": KeyChain.shared.read(key: "access")!,
                    "SesacKey": "\(APIKey.apiKey)"]
        case .refresh:
            return ["Content-Type": "application/json",
                    "RefreshToken": KeyChain.shared.read(key: "refresh") ?? "",
                    "Authorization": KeyChain.shared.read(key: "access") ?? "",
                    "SesacKey": "\(APIKey.apiKey)"]
        case .getWorkSpaceList, .getMyProfile, .getChannelList:
            return ["Content-Type": "application/json",
                    "Authorization": KeyChain.shared.read(key: "access")!,
                    "SesacKey": "\(APIKey.apiKey)"]
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .kakaoLogin(let access, let refresh):
            return ["oauthToken": access,
                    "deviceToken": refresh]
        case .emailValidate(email: let email):
            return ["email": email]
        case .register(email: let email, password: let password, nickname: let nickname, phone: let phone, deviceToken: let token):
            return ["email": email, "password": password, "nickname": nickname, "phone": phone ?? "", "deviceToken": token ?? ""]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
//        print("🩵", request.headers)
        
        if case .refresh = self {
            return request
        }
        
        switch self {
        case .makeWorkSpace, .getWorkSpaceList, .getMyProfile, .getChannelList:
            return try URLEncoding.default.encode(request, with: parameters)
        default:
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            return request  
        }
    }
}

extension Router {
    var multipart: MultipartFormData {
        let multipartFormData = MultipartFormData()
        
        switch self {
        case .makeWorkSpace(let model):
            let param: [String: Any] = [
                "name": model.name,
                "description": model.description ?? "",
                "image": model.image
            ]
            return makeMultipartFormdata(params: param, with: "workSpace")
            
        default: return MultipartFormData()
        }
    }
    
    func makeMultipartFormdata(params: [String: Any], with imageFileName: String) -> MultipartFormData {
        
        let multipart = MultipartFormData()
        
        switch self {
        case .makeWorkSpace(let makeWorkSpace):
            let name = makeWorkSpace.name.data(using: .utf8) ?? Data()
            let description = makeWorkSpace.description?.data(using: .utf8) ?? Data()
            let image = makeWorkSpace.image
            
            multipart.append(name, withName: "name")
            multipart.append(description, withName: "description")
            multipart.append(image, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            
            return multipart
            
        default: return MultipartFormData()
        }
    }
}
