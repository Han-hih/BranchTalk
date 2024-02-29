//
//  SocialLoginViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit
import AuthenticationServices

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
    
    private let viewModel = SocialLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
    }
    
    @objc func appleButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.email, .fullName]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
    }
    
    @objc func kakaoButtonTapped() {
        viewModel.kakaoLoginRequest { result in
            let userID = UserDefaults.standard.integer(forKey: "userID")
            if result.userID == userID {
                self.viewModel.getWorkSpaceList()
            } else {
                ViewMove.shared.goStartWorkSpaceView()
            }
        }
    }
    
    @objc func emailButtonTapped() {
        let vc = EmailLoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
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

extension SocialLoginViewController: ASAuthorizationControllerDelegate {
    
    //애플로 로그인 실패한 경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("Login Failed \(error.localizedDescription)")
        
    }
    
    //애플로 로그인 성공한 경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                print(appleIDCredential)
                let userIdential = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                guard let token = appleIDCredential.identityToken,
                      let tokenToString = String(data: token, encoding: .utf8) else { print("Token Error")
                    return
                }
                
                //UserDefaults
                print(userIdential)
                print(fullName ?? "No fullName")
                print(email ?? "No Email")
                print(tokenToString)
                UserDefaults.standard.setValue(userIdential, forKey: "User")
                UserDefaults.standard.setValue(email, forKey: "nickname")
                
                //이메일, 토큰, 이름 -> UserDefaults & API로 서버에 POST
                //서버에 Request 후 Response를 받게 되면, 성공시 화면 전환
                
                NetworkManager.shared.request(
                    type: LoginResult.self,
                    api: .appleLogin(
                        idToken: UserDefaults.standard.string(forKey: "User") ?? "",
                        nickname: UserDefaults.standard.string(forKey: "nickname") ?? "",
                        deviceToken: UserDefaults.standard.string(forKey: "FireBaseToken") ?? ""
                    )) { result in
                        switch result {
                        case .success(let response):
                            KeyChain.shared.keyChainSetting(
                                id: response.userID,
                                access: response.token.accessToken,
                                refresh: response.token.refreshToken
                            )
                        case .failure(let error):
                            print(error)
                        }
                    }
         
                DispatchQueue.main.async {
                    self.getWorkSpaceList()
                }
                
            case let passwordCredential as ASPasswordCredential:
                
                let username = passwordCredential.user
                let password = passwordCredential.password

                print(username, password)
                
            default: break
            }
        }

    func getWorkSpaceList() {
        NetworkManager.shared.request(type: [WorkSpaceList].self, api: Router.getWorkSpaceList) { result in
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

extension SocialLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
