//
//  SocialLoginViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class SocialLoginViewModel {
    
    func kakaoLoginRequest(completion: @escaping (KakaoResult) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    guard let access = oauthToken?.accessToken else { return }
                    guard let refresh = oauthToken?.refreshToken else { return }
                    
                    NetworkManager.shared.request(
                        type: KakaoResult.self,
                        api: Router.kakaoLogin(access: access, refresh: refresh)) { result in
                            switch result {
                            case .success(let response):
                                print("🤩", response)
                                completion(response)
                            case .failure(let error):
                                print("🧐", error)
                            }
                        }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    NetworkManager.shared.request(
                        type: KakaoResult.self,
                        api: Router.kakaoLogin(access: oauthToken?.accessToken ?? "", refresh: oauthToken?.refreshToken ?? "")) { result in
                            switch result {
                            case .success(let response):
                                print("🤩", response)
                                completion(response)
                            case .failure(let error):
                                print("🧐", error)
                            }
                        }
                }
            }
        }
    }
}
