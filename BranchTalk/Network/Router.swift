//
//  Router.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    case deviceToken(token: String)
    case kakaoLogin(access: String, deviceToken: String?)
    case appleLogin(idToken: String, nickname: String, deviceToken: String?)
    case emailLogin(email: String, pw: String, deviceToken: String?)
    case emailValidate(email: String)
    case register(email: String, password: String, nickname: String, phone: String?, deviceToken: String?)
    case makeWorkSpace(makeWorkSpace)
    case refresh
    case getWorkSpaceList
    case getOneWorkSpaceList(id: Int)
    case getMyProfile
    case getChannelList(id: Int)
    case unreadChatting(id: Int, name: String, after: String?)
    case getDmList(id: Int)
    case createChannel(id: Int, name: String, desc: String)
    case getAllMyChannel(id: Int)
    case getAllChannel(id: Int)
    case getChannelChatting(cursor_date: String?, name: String, id: Int)
    case getOneChannel(name: String, id: Int)
    case postChatting(name: String, id: Int, ChatRequestBody)
    
    private var baseURL: URL {
        guard let url = URL(string: APIKey.baseURL) else { fatalError() }
        return url
    }
    
    private var method: HTTPMethod {
        switch self {
        case .deviceToken, .kakaoLogin, .appleLogin, .emailLogin, .emailValidate, .register, .makeWorkSpace, .createChannel, .postChatting:
            return .post
        case .refresh, .getWorkSpaceList, .getOneWorkSpaceList, .getMyProfile, .getChannelList, .unreadChatting, .getDmList, .getAllMyChannel, .getAllChannel, .getChannelChatting, .getOneChannel:
            return .get
        }
    }
    
    private var path: String {
        switch self {
        case .deviceToken:
            return "v1/users/deviceToken"
        case .kakaoLogin:
            return "/v1/users/login/kakao"
        case .appleLogin:
            return "/v1/users/login/apple"
        case .emailLogin:
            return "/v2/users/login"
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
        case .getOneWorkSpaceList(let id):
            return "/v1/workspaces/\(id)"
        case .getMyProfile:
            return "v1/users/my"
        case .getChannelList(let id):
            return "v1/workspaces/\(id)/channels"
        case .unreadChatting(let id, let name, _):
            return "v1/workspaces/\(id)/channels/\(name)/unreads"
        case .getDmList(let id):
            return "v1/workspaces/\(id)/dms"
        case .createChannel(let id, _, _):
            return "v1/workspaces/\(id)/channels"
        case .getAllMyChannel(let id):
            return "/v1/workspaces/\(id)/channels/my"
        case .getAllChannel(let id):
            return "/v1/workspaces/\(id)/channels"
        case .getChannelChatting(_, let name, let id):
            return "/v1/workspaces/\(id)/channels/\(name)/chats"
        case .getOneChannel(let name, id: let id):
            return "/v1/workspaces/\(id)/channels/\(name)"
        case .postChatting(let name, let id, _):
            return "/v1/workspaces/\(id)/channels/\(name)/chats"
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .deviceToken, .kakaoLogin, .appleLogin, .emailLogin, .emailValidate, .register:
            return ["Content-Type": "application/json",
                    "SesacKey": "\(APIKey.apiKey)"]
        case .makeWorkSpace, .postChatting:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": KeyChain.shared.read(key: "access")!,
                    "SesacKey": "\(APIKey.apiKey)"]
        case .refresh:
            return ["Content-Type": "application/json",
                    "RefreshToken": KeyChain.shared.read(key: "refresh") ?? "",
                    "Authorization": KeyChain.shared.read(key: "access") ?? "",
                    "SesacKey": "\(APIKey.apiKey)"]
        case .getWorkSpaceList, .getOneWorkSpaceList, .getMyProfile, .getChannelList, .unreadChatting, .getDmList, .createChannel, .getAllChannel, .getAllMyChannel, .getChannelChatting, .getOneChannel:
            return ["Content-Type": "application/json",
                    "Authorization": KeyChain.shared.read(key: "access")!,
                    "SesacKey": "\(APIKey.apiKey)"]
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .deviceToken(let token):
            return ["deviceToken": token]
            
            
        case .kakaoLogin(let access, let device):
            return ["oauthToken": access,
                    "deviceToken": device ?? ""]
        case .appleLogin(let id, let name, let token):
            return ["idToken": id,
                    "nickname": name,
                    "deviceToken": token ?? ""]
        case .emailLogin(let email, let pw, let token):
            return ["email": email,
                    "password": pw,
                    "deviceToken": token ?? ""]
        case .emailValidate(email: let email):
            return ["email": email]
        case .register(email: let email, password: let password, nickname: let nickname, phone: let phone, deviceToken: let token):
            return ["email": email, "password": password, "nickname": nickname, "phone": phone ?? "", "deviceToken": token ?? ""]
        case .createChannel(_, let name, let desc):
            return [ "name": name,
                     "description": desc]
        case .getChannelChatting(let cursor?, let name, let id):
            return ["cursor_date": cursor,
                    "name": name,
                    "workspace_id": id]
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = header
        
        print("🩵", request.headers)
        
        
        if case .refresh = self {
            return request
        }
        
        switch self {
        case .makeWorkSpace, .getWorkSpaceList, .getOneWorkSpaceList, .getMyProfile, .getChannelList, .getDmList, .getAllChannel, .getAllMyChannel, .getChannelChatting, .getOneChannel, .postChatting:
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
       
        case .postChatting(_, _, let model):
            let param: [String: Any] = [
                "content": model.content,
                "files": model.files
            ]
            return makeMultipartFormdata(params: param, with: "chatPost")
        default: return multipartFormData
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
            
        case .postChatting(_, _, let chatRequest):
            let text = chatRequest.content.data(using: .utf8) ?? Data()
            let files = chatRequest.files
            
            multipart.append(text, withName: "content")
            
            for file in files {
                multipart.append(file, withName: "files", fileName: "file.jpeg", mimeType: "image/jpeg")
            }
            
            return multipart
            
        default: return MultipartFormData()
        }
        
    }
}
