//
//  CommonError.swift
//  BranchTalk
//
//  Created by 황인호 on 1/8/24.
//

import Foundation

protocol ErrorProtocol: Error {
    var rawValue: String { get }
    var message: String { get }
}

enum CommonError: String, ErrorProtocol {
    
    case tokenAuthenticationFailed = "E02"
    case failedLogin = "E03"
    case expiredAccessToken = "E05"
    case wrongRequest = "E11"
    case duplicate = "E12"
    case coinShortage = "E21"
    
    case unknownRouterRoutes = "E97"
    case severError = "E99"
    
    var message: String {
        switch self {
        case .tokenAuthenticationFailed:
            return "토큰 인증 실패"
        case .failedLogin:
            return "로그인 실패"
        case .expiredAccessToken:
            return "액세스 토큰 만료"
        case .wrongRequest:
            return "잘못된 요청"
        case .duplicate:
            return "중복_데이터"
        case .coinShortage:
            return "새싹 코인 부족"
            
        case.unknownRouterRoutes:
            return "알 수 없는 라우터 경로"
        case .severError:
            return "서버에러"
        }
    }
    
    
}
