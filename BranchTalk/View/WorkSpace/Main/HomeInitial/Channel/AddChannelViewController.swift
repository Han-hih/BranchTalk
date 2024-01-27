//
//  AddChannelViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/25/24.
//

import UIKit

final class AddChannelViewController: BaseViewController {
    
    private let nameLabel = {
        let lb = CustomTitle2Label()
        lb.text = "채널 이름"
        return lb
    }()
    
    private let nameTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "채널 이름을 입력하세요 (필수)"
        return tf
    }()
    
    private let descriptionLabel = {
        let lb = CustomTitle2Label()
        lb.text = "채널 설명"
        return lb
    }()
    
    private let descriptionTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "채널을 설명하세요 (옵션)"
        return tf
    }()
    
    private let createButton = {
        let bt = GreenCustonButton()
        bt.setTitle("생성", for: .normal)
        return bt
    }()
    
    private let viewModel = AddChannelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
    }
    
    override func bind() {
        super.bind()
        let input = AddChannelViewModel.Input(
            nameTextFieldInput: nameTextField.rx.controlEvent(.editingChanged).withLatestFrom(nameTextField.rx.text.orEmpty.asObservable()),
            createButtonTapped: createButton.rx.tap.asObservable(),
            nameInput: nameTextField.rx.text.orEmpty.asObservable(),
            descInput: descriptionTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.nameTextFieldInput
            .bind(with: self) { owner, value in
                owner.createButton.isEnabled = value
                owner.createButton.backgroundColor = value ? Colors.BrandGreen.CutsomColor : Colors.BrandInactive.CutsomColor
            }
            .disposed(by: disposeBag)
    }
    
    override func setUI() {
        super.setUI()
        [nameLabel, nameTextField, descriptionLabel, descriptionTextField, createButton].forEach {
            view.addSubview($0)
        }
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
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
        navigationItem.title = "채널 생성"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }

    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension AddChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField :
            return self.descriptionTextField.becomeFirstResponder()
        case descriptionTextField:
            return descriptionTextField.resignFirstResponder()
        default:
            return true
        }
    }
}
