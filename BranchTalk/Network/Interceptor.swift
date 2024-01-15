//
//  Interceptor.swift
//  BranchTalk
//
//  Created by 황인호 on 1/10/24.
//

import UIKit
import Alamofire

class Interceptor: RequestInterceptor {
    
    static let shared = Interceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("\(APIKey.baseURL)") == true,
              let accessToken = KeyChain.shared.read(key: "access") // 기기에 저장된 토큰들
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        
        guard let refreshToken = KeyChain.shared.read(key: "refresh") else { return }
 
        NetworkManager.shared.refreshRequest(type: TokenResponse.self, api: .refresh) { response in
            print(response)
            switch response {
            case .success(let response):
                print(response.accessToken)
                KeyChain.shared.create(key: "access", token: response.accessToken)
                print("retry 성공")
                completion(.retry)
            case .failure(let error):
                print(error.message)
                let refreshErrorArray = ["E06", "E02", "E03"]
                
                if refreshErrorArray.contains(error.rawValue) {
                    ViewMove.shared.goLoginView()
                }
                
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
