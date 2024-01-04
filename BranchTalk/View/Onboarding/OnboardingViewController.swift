//
//  ViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/2/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let label = {
        let label = UILabel()
        label.font = Font.title1Bold()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "브랜치톡을 사용하면 어디서나\n팀을 모을 수 있습니다"
        return label
    }()
    
    private let imageView = UIImageView(image: UIImage(named: "onboarding"))
    
    private lazy var startButton = {
        let bt = GreenCustonButton()
        bt.setTitle("시작하기", for: .normal)
        bt.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func startButtonTapped() {
        let vc = SocialLoginViewController()
        
        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customDetent")) { _ in
            return 250
        }
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    override func setUI() {
        [label, imageView, startButton].forEach {
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
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.bottom.equalTo(view).inset(45)
        }
    }
}

