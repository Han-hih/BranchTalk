//
//  RegisterViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

final class RegisterViewController: BaseViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        
    }
    
    override func setNav() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
       
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    override func setUI() {
        [emailCheckButton, emailLabel, emailTextField, nicknameLabel, nickTextField, callLabel, callTextField, pwLabel, pwTextField, checkPWLabel, checkPWTextField, registerButton].forEach {
            view.addSubview($0)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
            make.height.equalTo(44)
        }

        emailCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.top)
            make.leading.equalTo(emailTextField.snp.trailing).offset(12)
            make.trailing.equalTo(view.snp.trailing).inset(24)
            make.height.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        callLabel.snp.makeConstraints { make in
            make.top.equalTo(nickTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        callTextField.snp.makeConstraints { make in
            make.top.equalTo(callLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        callLabel.snp.makeConstraints { make in
            make.top.equalTo(nickTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        callTextField.snp.makeConstraints { make in
            make.top.equalTo(callLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(callTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        checkPWLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        checkPWTextField.snp.makeConstraints { make in
            make.top.equalTo(checkPWLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(checkPWTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
    }
    
    private lazy var emailCheckButton = {
        let bt = GrayCustomButton()
        bt.setTitle("  중복 확인  ", for: .normal)
        return bt
    }()
    
    private let emailLabel = {
        let lb = CustomTitle2Label()
        lb.text = "이메일"
       return lb
    }()
    
    private let emailTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "이메일을 입력하세요"
        return tf
    }()
    
    private let nicknameLabel = {
        let lb = CustomTitle2Label()
        lb.text = "닉네임"
       return lb
    }()
    
    private let nickTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "닉네임을 입력하세요"
        return tf
    }()
    
    private let callLabel = {
        let lb = CustomTitle2Label()
        lb.text = "연락처"
       return lb
    }()
    
    private let callTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "전화번호를 입력하세요"
        return tf
    }()
    
    private let pwLabel = {
        let lb = CustomTitle2Label()
        lb.text = "비밀번호"
       return lb
    }()
    
    private let pwTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "비밀번호를 입력하세요"
        return tf
    }()
    
    private let checkPWLabel = {
        let lb = CustomTitle2Label()
        lb.text = "비밀번호 확인"
       return lb
    }()
    
    private let checkPWTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "비밀번호를 한 번 더 입력하세요"
        return tf
    }()
    
    private lazy var registerButton = {
        let bt = GrayCustomButton()
        bt.setTitle("가입하기", for: .normal)
        return bt
    }()
}
