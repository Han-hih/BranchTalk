//
//  SocialLoginViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

final class SocialLoginViewController: UIViewController {
    
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
        view.backgroundColor = .white
        setUI()
        setupGestureRecognizer()
    }
    
    @objc func appleButtonTapped() {
        print("애플로그인탭")
    }
    
    @objc func kakaoButtonTapped() {
        print("카카오탭")
    }
    
    @objc func emailButtonTapped() {
        print("이메일로 계속하기")
    }
    
    @objc func newButtonTapped() {
        print("새롭게 회원가입")
    }
    
    private func setUI() {
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
        print("새롭게 회원가입 탭")
    }
}
