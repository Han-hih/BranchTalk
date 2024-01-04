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
    
    let userdefault = UserDefaults()
    
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
                                self.keyChainSetting(
                                    id: response.userID,
                                    access: response.token.accessToken,
                                    refresh: response.token.refreshToken
                                )
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
                    guard let access = oauthToken?.accessToken else { return }
                    guard let refresh = oauthToken?.refreshToken else { return }
                    
                    NetworkManager.shared.request(
                        type: KakaoResult.self,
                        api: Router.kakaoLogin(access: access, refresh: refresh)) { result in
                            switch result {
                            case .success(let response):
                                print("🤩", response)
                                self.keyChainSetting(
                                    id: response.userID,
                                    access: response.token.accessToken,
                                    refresh: response.token.refreshToken
                                )
                                completion(response)
                            case .failure(let error):
                                print("🧐", error)
                            }
                        }
                }
            }
        }
    }
    private func keyChainSetting(id: Int, access: String, refresh: String) {
        self.userdefault.setValue(id, forKey: "userID")
        KeyChain.shared.create(key: "access", token: access)
        KeyChain.shared.create(key: "refresh", token: refresh)
    }
    
}
