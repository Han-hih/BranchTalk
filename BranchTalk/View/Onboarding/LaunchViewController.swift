//
//  LaunchViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/11/24.
//

import UIKit

final class LaunchViewController: BaseViewController {
    
    private let label = {
        let label = UILabel()
        label.font = Font.title1Bold()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "브랜치톡을 사용하면 어디서나\n팀을 모을 수 있습니다"
        return label
    }()
    
    private let imageView = UIImageView(image: UIImage(named: "onboarding"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        checkToken()
    }
    
    private func checkToken() {
        guard let accessToken = KeyChain.shared.read(key: "access") else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !accessToken.isEmpty {
                NetworkManager.shared.request(type: TokenResponse.self, api: Router.refresh, completion: { [weak self] result in
                    switch result {
                    case .success(let response):
                        print("토큰 재발급 성공")
                        KeyChain.shared.create(key: "access", token: response.accessToken)
                        // 1. 워크스페이스 유무에 따라 홈뷰 이동
                        self?.goToMainView()
                        
                    case .failure(let error):
                        print(error)
                        self?.goToLoginView()
                    }
                }
                )} else {
                    self.goToLoginView()
                }
        }
    }
    
    private func goToMainView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        NetworkManager.shared.request(type: GetWorkSpaceList.self, api: Router.getWorkSpaceList, completion: { result in
            switch result {
            case .success(let response):
                print(response)
                if response.count > 0 {
                    let vc = HomeInitialViewController()
                    sceneDelegate?.window?.rootViewController = vc
                } else {
                    let vc = HomeEmptyViewController()
                    sceneDelegate?.window?.rootViewController = vc
                }
                
                sceneDelegate?.window?.makeKey()
            case .failure(let error):
                print(error)
                self.goToLoginView()
            }
        })
    }
    
    private func goToLoginView() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = SocialLoginViewController()
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }
    
    
    
    override func setUI() {
        super.setUI()
        [label, imageView].forEach {
            view.addSubview($0)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(93)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(12)
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    
}

