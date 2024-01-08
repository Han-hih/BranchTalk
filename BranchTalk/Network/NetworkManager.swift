//
//  NetworkManager.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation
import Alamofire
import RxSwift
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
    // 이메일 중복확인 함수
    func requestEmailDuplicate(api: Router) -> Single<Result<Any, Error>> {
        return Single.create { single in
            let request = AF.request(api).response { response in
                switch response.result {
                case .success(let data):
                    single(.success(.success(data)))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestSingle<T: Decodable>(
           type: T.Type,
           api: Router
       ) -> Single<Result<T, Error>> {
           return Single.create { [weak self] single in
               self?.request(type: T.self, api: api, completion: { result in
                   switch result {
                   case .success(let success):
                       single(.success(.success(success)))
                   case .failure(let error):
                       single(.success(.failure(error)))
                   }
               })
               return Disposables.create()
           }
       }
}

