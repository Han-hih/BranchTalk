//
//  CustomAlertView.swift
//  BranchTalk
//
//  Created by 황인호 on 1/31/24.
//

import UIKit

protocol CustomAlertDelegate {
    func confirm()
}

enum AlertType {
    case onlyConfirm
    case canCancel
}

class CustomAlertViewController: UIViewController {
    
    var delegate: CustomAlertDelegate?
    
    private let alertView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = Colors.BrandWhite.CutsomColor
        return view
    }()
    
    let titleLabel = {
        let lb = CustomTitle2Label()
        return lb
    }()
    
    let descriptionLabel = {
        let lb = CustomBodyLabel()
        lb.numberOfLines = 0
        return lb
    }()
    
    let buttonStackView = {
        let st = UIStackView()
        st.spacing = 8
        st.axis = .horizontal
        st.distribution = .fillEqually
        st.isUserInteractionEnabled = true
        return st
    }()
    
    lazy var confirmButton = {
        let bt = GreenCustonButton()
        bt.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
       return bt
    }()
    
    lazy var cancelButton = {
        let bt = GrayCustomButton()
        bt.setTitle("취소", for: .normal)
        bt.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        setUI()
        
    }
    
    func switchAlertType(title: String, desc: String, buttonTitle: String, alertType: AlertType) {
        self.titleLabel.text = title
        self.descriptionLabel.text = desc
        self.confirmButton.setTitle(buttonTitle, for: .normal)
        
        switch alertType {
        case .onlyConfirm:
            cancelButton.isHidden = true
            
        case .canCancel:
            cancelButton.isHidden = false
        }
    }
    
    
    
    private func setUI() {
        
        [cancelButton, confirmButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        [alertView, titleLabel, descriptionLabel, buttonStackView].forEach { view.addSubview($0) }
        
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(138)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(alertView.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(18)
            make.horizontalEdges.equalTo(alertView).inset(16.5)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalTo(alertView).inset(24)
            make.centerX.equalTo(alertView)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.bottom.equalTo(alertView).inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    @objc func confirmButtonTapped() {
        self.delegate?.confirm()
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
}
