//
//  CreateWorkSpaceViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/8/24.
//

import UIKit
import PhotosUI
import RxSwift

final class CreateWorkSpaceViewController: BaseViewController {
    
    private let imageView = {
        let view = UIImageView()
        view.backgroundColor = Colors.BrandGreen.CutsomColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let wordingImageView = UIImageView(image: UIImage(named: "workspace"))
    
    private lazy var cameraButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "Camera"), for: .normal)
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 12
        bt.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private let nameLabel = {
        let lb = CustomTitle2Label()
        lb.text = "워크스페이스 이름"
        return lb
    }()
    
    private let nameTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "워크스페이스 이름을 입력하세요 (필수)"
        return tf
    }()
    
    private let descriptionLabel = {
        let lb = CustomTitle2Label()
        lb.text = "워크스페이스 설명"
        return lb
    }()
    
    private let descriptionTextField = {
        let tf = CustomRegisterTextField()
        tf.placeholder = "워크스페이스를 설명하세요 (옵션)"
        return tf
    }()
    
    private let completButton = {
        let bt = GreenCustonButton()
        bt.setTitle("완료", for: .normal)
        return bt
    }()
    
    private var itemProviders: [NSItemProvider] = []
    
    private let viewModel = CreateWorkSpaceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
    }

    override func Bind() {
        super.Bind()
        let input = CreateWorkSpaceViewModel.Input(nameTextFieldInput: nameTextField.rx.controlEvent(.editingChanged).withLatestFrom(nameTextField.rx.text.orEmpty.asObservable()))
        
        let output = viewModel.transform(input: input)
        
        output.nameTextFieldInput
            .bind(with: self) { owner, value in
                owner.completButton.isEnabled = value
                owner.completButton.backgroundColor = value ? Colors.BrandGreen.CutsomColor : Colors.BrandInactive.CutsomColor
            }
            .disposed(by: disposeBag)
            
    }
    
    override func setUI() {
        super.setUI()
        [imageView, wordingImageView, cameraButton, nameLabel, nameTextField, descriptionLabel, descriptionTextField, completButton].forEach {
            view.addSubview($0)
        }
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }
        wordingImageView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
        cameraButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
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
        completButton.snp.makeConstraints { make in
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
        navigationItem.title = "워크스페이스 생성"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }
    
    @objc func photoButtonTapped() {
        presentPicker()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension CreateWorkSpaceViewController: UITextFieldDelegate {
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

extension CreateWorkSpaceViewController: PHPickerViewControllerDelegate {
    private func presentPicker() {
        var config = PHPickerConfiguration()
        
        config.filter = .images
        config.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    private func displayImage() {
        guard let itemProvider = itemProviders.first else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self,
                      let image = image as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.wordingImageView.image = nil
                }
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        displayImage()
    }
}

