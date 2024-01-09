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
        completion: @escaping (Result<T, CommonError>) -> Void
    ) {
        AF.request(api)
            .responseDecodable(of: T.self) { response in
                if let data = response.data  {
                    let string = String(decoding: data, as: UTF8.self)
                }
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let networkError = try JSONDecoder().decode(CommonErrorReason.self, from: data)
                            let errorString = networkError.errorCode
                            let errorEnum = CommonError(rawValue: errorString) ?? CommonError.unknownError
                            completion(.failure(errorEnum))
                        }
                        catch {
                            completion(.failure(CommonError.unknownError))
                        }
                    }
                }
            }
    }
    
    // 이메일 중복확인 함수
    func requestEmailDuplicate(api: Router) -> Single<Result<Any, CommonError>> {
        return Single.create { single in
            let request = AF.request(api).response { response in
                switch response.result {
                case .success(let data):
                    //    print("🩵", String(data: response.data!, encoding: .utf8))
                    if let data = response.data {
                        do {
                            let networkError = try JSONDecoder().decode(CommonErrorReason.self, from: data)
                            let errorString = networkError.errorCode
                            let errorEnum = CommonError(rawValue: errorString) ?? CommonError.unknownError
                            if errorEnum.rawValue == "E12" {
                                single(.success(.failure(errorEnum)))
                            }
                        }
                        catch {
                            single(.success(.failure(CommonError.unknownError)))
                        }
                    }
                    else {
                        single(.success(.success(data)))
                    }
                    
                case .failure(let error):
                    single(.failure(error))
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
    ) -> Single<Result<T, CommonError>> {
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
