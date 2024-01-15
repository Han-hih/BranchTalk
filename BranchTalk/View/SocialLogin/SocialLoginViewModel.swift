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
import UIKit

class SocialLoginViewModel {
    
    func kakaoLoginRequest(completion: @escaping (LoginResult) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    guard let access = oauthToken?.accessToken else { return }
                    guard let refresh = oauthToken?.refreshToken else { return }
                    
                    NetworkManager.shared.request(
                        type: LoginResult.self,
                        api: Router.kakaoLogin(access: access, refresh: refresh)) { result in
                            switch result {
                            case .success(let response):
                                KeyChain.shared.keyChainSetting(
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
                        type: LoginResult.self,
                        api: Router.kakaoLogin(access: access, refresh: refresh)) { result in
                            switch result {
                            case .success(let response):
                                print("🤩", response)
                                KeyChain.shared.keyChainSetting(
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
    
    func getWorkSpaceList() {
        NetworkManager.shared.request(type: GetWorkSpaceList.self, api: Router.getWorkSpaceList) { result in
            switch result {
            case .success(let response):
                print(response.count)
                if response.count > 0 {
                    ViewMove.shared.goHomeInitialView()
                } else {
                    ViewMove.shared.goStartWorkSpaceView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
