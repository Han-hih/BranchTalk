//
//  NetworkManager.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func request<T: Decodable>(
        type: T.Type,
        api: Router,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(api)
            .responseDecodable(of: T.self) { response in
                print("🩵", String(data: response.data!, encoding: .utf8))
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
