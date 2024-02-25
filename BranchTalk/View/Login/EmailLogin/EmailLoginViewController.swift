//
//  EmailLoginViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 2/25/24.
//

import UIKit

final class EmailLoginViewController: BaseViewController {
    
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
    
    private let passwordLabel = {
        let lb = CustomTitle2Label()
        lb.text = "비밀번호"
        return lb
    }()
    
    private let passwordTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "비밀번호를 입력하세요"
        return tf
    }()
    
    private lazy var createButton = {
        let bt = GreenCustonButton()
        bt.setTitle("로그인", for: .normal)
        bt.addTarget(self, action: #selector(loginbuttonTap), for: .touchUpInside)
        return bt
    }()
    
    private let viewModel = EmailLoginViewModel()
    
    override func bind() {
        super.bind()
        let input = EmailLoginViewModel.Input(
            loginButtonTapped: createButton.rx.tap.asObservable(),
            emailInput:emailTextField.rx.controlEvent(.editingChanged).withLatestFrom(
                emailTextField.rx.text.orEmpty.asObservable()
            ),
            passInput: passwordTextField.rx.controlEvent(.editingChanged).withLatestFrom(passwordTextField.rx.text.orEmpty.asObservable()                                                                       )
        )
        
        let output = viewModel.transform(input: input)
        
        output.emailTextFieldInput
            .bind(with: self) { owner, value in
                owner.createButton.isEnabled = value
                owner.createButton.backgroundColor = value ? Colors.BrandGreen.CutsomColor : Colors.BrandInactive.CutsomColor
            }
            .disposed(by: disposeBag)
//        
//        output.createButtonTapped
//            .bind(with: self) { owner, _ in
//                    ViewMove.shared.goHomeInitialView()
//            }
//            .disposed(by: disposeBag)
    }
    
    override func setUI() {
        super.setUI()
        [emailLabel, emailTextField, passwordLabel, passwordTextField, createButton].forEach {
            view.addSubview($0)
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        createButton.snp.makeConstraints { make in
            make.top.equalTo(view.keyboardLayoutGuide).offset(-50)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
    
    override func setNav() {
        super.setNav()
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "이메일 로그인"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }
    @objc func loginbuttonTap() {
        viewModel.emailLogin(
            email: emailTextField.text ?? "",
            pw: passwordTextField.text ?? "") { result in
                let userID = UserDefaults.standard.integer(forKey: "userID")
                if result.userID == userID {
                    self.viewModel.getWorkSpaceList()
                } else {
                    ViewMove.shared.goStartWorkSpaceView()
                }
            }
    }
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField :
            return self.passwordTextField.becomeFirstResponder()
        case passwordTextField:
            return passwordTextField.resignFirstResponder()
        default:
            return true
        }
    }
}

