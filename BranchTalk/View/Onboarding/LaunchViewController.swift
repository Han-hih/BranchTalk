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
        guard let accessToken = KeyChain.shared.read(key: "access") else { return ViewMove.shared.goLoginView() }
        print(accessToken)
            goToMainView()
    }
    
    private func goToMainView() {
        NetworkManager.shared.request(type: GetWorkSpaceList.self, api: Router.getWorkSpaceList) { result in
            print(result)
            switch result {
            case .success(let response):
                print(response)
                if response.count > 0 {
                    ViewMove.shared.goHomeInitialView()
                } else {
                    ViewMove.shared.goHomeEmptyView()
                }
            case .failure(let error):
                print(error)
                ViewMove.shared.goLoginView()
            }
        }
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

