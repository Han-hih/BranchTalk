//
//  SocialLoginViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

final class SocialLoginViewController: BaseViewController {
    
    private lazy var appleLoginButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "AppleLogin"), for: .normal)
        bt.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private lazy var kakaoLoginButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "KakaoLogin"), for: .normal)
        bt.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private lazy var emailLoginButton = {
        let bt = GreenCustonButton()
        bt.setImage(UIImage(named: "icon"), for: .normal)
        bt.setTitle(" 이메일로 계속하기", for: .normal)
        bt.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private let newRegiterLabel = {
        let lb = UILabel()
        lb.font = Font.title2Bold()
        lb.text = "또는 새롭게 회원가입 하기"
        lb.textAlignment = .center
        let attributedStr = NSMutableAttributedString(string: lb.text!)
        attributedStr.addAttribute(.foregroundColor, value: Colors.BrandBlack.CutsomColor, range: (lb.text! as NSString).range(of: "또는"))
        attributedStr.addAttribute(.foregroundColor, value: Colors.BrandGreen.CutsomColor, range: (lb.text! as NSString).range(of: "새롭게 회원가입 하기"))
        lb.attributedText = attributedStr
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
    }
    
    @objc func appleButtonTapped() {
        print("애플로그인탭")
    }
    
    @objc func kakaoButtonTapped() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    NetworkManager.shared.request(
                        type: KakaoResult.self,
                        api: Router.kakaoLogin(access: oauthToken?.accessToken ?? "", refresh: oauthToken?.refreshToken ?? "")) { result in
                            switch result {
                            case .success(let response):
                                print("🤩", response)
                                let vc = StartWorkSpaceViewController()
                                vc.nickName = response.nickname
                                let nav = UINavigationController(rootViewController: vc)
                                nav.modalPresentationStyle = .fullScreen
                                self.present(nav, animated: true)
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
                    print(oauthToken ?? "")
                }
            }
        }
    }
    
    @objc func emailButtonTapped() {
        print("이메일로 계속하기")
    }
    
    override func setUI() {
        [appleLoginButton, kakaoLoginButton, emailLoginButton, newRegiterLabel].forEach {
            view.addSubview($0)
        }
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(45)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(35)
        }
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appleLoginButton.snp.bottom).offset(13)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(35)
        }
        emailLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(13)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(35)
        }
        newRegiterLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLoginButton.snp.bottom).offset(13)
            make.horizontalEdges.equalToSuperview().inset(35)
        }
    }
}

extension SocialLoginViewController {
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newRegiterLabelTapped))
        newRegiterLabel.addGestureRecognizer(tapGestureRecognizer)
        newRegiterLabel.isUserInteractionEnabled = true
    }
    
    @objc private func newRegiterLabelTapped(_ tapRecognizer: UITapGestureRecognizer) {
        let vc = RegisterViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true)
    }
}
