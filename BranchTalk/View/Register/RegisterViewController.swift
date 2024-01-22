//
//  RegisterViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit
import RxCocoa

import IQKeyboardManagerSwift

final class RegisterViewController: BaseViewController {
    
    private let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        activeIQkeyboard()
        
    }
    
    override func bind() {
        super.bind()
        let input = RegisterViewModel.Input(
            emailHasOneLetter: emailTextField.rx.controlEvent(.editingChanged).withLatestFrom(emailTextField.rx.text.orEmpty.asObservable()),
            emailDuplicateTap: emailCheckButton.rx.tap.asObservable(), nonValidEmailDuplicateTap: emailCheckButton.rx.tap.asObservable(),
            nickValid: nickTextField.rx.controlEvent(.editingChanged).withLatestFrom(nickTextField.rx.text.orEmpty.asObservable()),
            phoneValid: phoneTextField.rx.text.orEmpty.asObservable(),
            passwordValid: pwTextField.rx.text.orEmpty.asObservable(),
            checkPasswordValid: checkPWTextField.rx.text.orEmpty.asObservable(),
            registerTap: registerButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.emailValid
            .asDriver()
            .drive(with: self, onNext: { owner, bool in
                owner.emailCheckButton.rx.backgroundColor.onNext(bool ? Colors.BrandGreen.CutsomColor : Colors.BrandInactive.CutsomColor)
                owner.emailCheckButton.rx.isEnabled.onNext(bool)
            })
            .disposed(by: disposeBag)
        
        output.emailDuplicateTap
            .asDriver()
            .drive(with: self) { owner, value in
                print(value)
                if value == "중복" {
                    owner.showToast(message: "중복 된 이메일 입니다.")
                }
                if value == "사용가능" {
                    owner.showToast(message: "사용 가능한 이메일입니다.")
                }
            }
            .disposed(by: disposeBag)
        
        output.nonValidEmailDuplicateTap
            .asDriver()
            .drive(with: self) { owner, bool in
                if bool == false {
                    owner.showToast(message: "이메일 형식이 올바르지 않습니다.")
                }
            }
            .disposed(by: disposeBag)
        
        output.registerActivate
            .subscribe(with: self, onNext: { owner, bool in
                owner.registerButton.rx.backgroundColor.onNext(bool ? Colors.BrandGreen.CutsomColor : Colors.BrandInactive.CutsomColor)
                owner.registerButton.rx.isEnabled.onNext(bool)
            })
            .disposed(by: disposeBag)
        
        output.falseValue
            .bind(with: self) { owner, values in
                let registerValueLabel = [owner.emailLabel, owner.nicknameLabel, owner.callLabel, owner.pwLabel, owner.checkPWLabel]
                
                for i in 0..<values.count {
                    registerValueLabel[i].textColor = values[i] ? Colors.BrandBlack.CutsomColor : Colors.BrandError.CutsomColor
                }
            }
            .disposed(by: disposeBag)
        
        output.emailToast
            .bind(with: self) { owner, value in
                if value {
                    owner.emailTextField.becomeFirstResponder()
                    owner.showToast(message: "이메일 중복 확인을 진행해주세요.")
                } else {
                    owner.emailTextField.becomeFirstResponder()
                    owner.showToast(message: "이미 가입된 회원입니다. 로그인을 진행해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        output.nickToast
            .bind(with: self) { owner, value in
                owner.nickTextField.becomeFirstResponder()
                owner.showToast(message: "닉네임은 1글자 이상 30글자 이내로 부탁드려요.")
            }
            .disposed(by: disposeBag)
        
        output.phoneToast
            .bind(with: self) { owner, value in
                owner.phoneTextField.becomeFirstResponder()
                owner.showToast(message: "잘못된 전화번호 형식입니다.")
            }
            .disposed(by: disposeBag)
        
        output.pwToast
            .bind(with: self) { owner, value in
                owner.pwTextField.becomeFirstResponder()
                owner.showToast(message: "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요.")
            }
            .disposed(by: disposeBag)
        
        output.chpwToast
            .bind(with: self) { owner, value in
                owner.checkPWTextField.becomeFirstResponder()
                owner.showToast(message: "작성하신 비밀번호가 일치하지 않습니다.")
            }
            .disposed(by: disposeBag)
        
        output.registerTap
            .bind(with: self) { owner, _ in
                let vc = StartWorkSpaceViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
        
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = false
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
        [emailCheckButton, emailLabel, emailTextField, nicknameLabel, nickTextField, callLabel, phoneTextField, pwLabel, pwTextField, checkPWLabel, checkPWTextField, registerButton].forEach {
            view.addSubview($0)
        }
        
        emailTextField.delegate = self
        nickTextField.delegate = self
        phoneTextField.delegate = self
        pwTextField.delegate = self
        checkPWTextField.delegate = self
        
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
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(callLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        callLabel.snp.makeConstraints { make in
            make.top.equalTo(nickTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(callLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(24)
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
            make.bottom.equalTo(view.snp.bottomMargin).inset(24)
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
        tf.keyboardType = UIKeyboardType.emailAddress
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
    
    private let phoneTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "전화번호를 입력하세요"
        tf.keyboardType = .numberPad
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
        tf.isSecureTextEntry = true
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
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let registerButton = {
        let bt = GrayCustomButton()
        bt.setTitle("가입하기", for: .normal)
        return bt
    }()
    
    private func activeIQkeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField :
            return self.nickTextField.becomeFirstResponder()
        case nickTextField:
            return self.phoneTextField.becomeFirstResponder()
        case phoneTextField:
            return self.pwTextField.becomeFirstResponder()
        case pwTextField:
            return checkPWTextField.becomeFirstResponder()
        case checkPWTextField:
            return checkPWTextField.resignFirstResponder()
        default:
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == phoneTextField else { return true }
        
        guard var currentText = textField.text else { return false }
        
        if string.isEmpty { // 입력값이 없을 때
            if currentText.last == "-" {
                currentText.removeLast()
            }
            else if !currentText.isEmpty {
                currentText.removeLast()
                textField.text = currentText
                return false
            }
        }
        
        if currentText.count > 2 {
            let index = currentText.index(currentText.startIndex, offsetBy: 2)
            let character = currentText[index]
            
            if character == "0" {
                if currentText.count == 3 || currentText.count == 8 {
                    currentText.append("-")
                }
                if currentText.count > 12 {
                    return false
                }
            } else if character == "1" {
                if currentText.count == 3 || currentText.count == 7 {
                    currentText.append("-")
                }
                if currentText.count > 11 {
                    return false
                }
            }
            else {
                if currentText.count == 3 || currentText.count == 8 {
                    currentText.append("-")
                }
                if currentText.count > 12 {
                    return false
                }
            }
        }
        textField.text = currentText
        return true
    }
    
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 75, y: self.registerButton.frame.origin.y - 40, width: 175, height: 36))
        toastLabel.backgroundColor = Colors.BrandGreen.CutsomColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = Font.body()
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

