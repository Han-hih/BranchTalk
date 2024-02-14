//
//  ChannelChattingViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 2/1/24.
//

import UIKit
import RxSwift

final class ChannelChattingViewController: BaseViewController {
    
    private let chatGroupView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        return view
    }()
    
    private let plusButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "plus"), for: .normal)
        return bt
    }()
    
    private lazy var textView = {
        let tv = UITextView()
        tv.text = textViewPlaceholder
        tv.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        tv.textColor = Colors.TextSecondary.CutsomColor
        tv.font = Font.body()
        tv.delegate = self
        tv.textContainerInset = .zero
        tv.sizeToFit()
        tv.isScrollEnabled = false
        
        return tv
    }()
    
    private let sendButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "send"), for: .normal)
        return bt
    }()
    
    var channelTitle = ""
    
    private let textViewPlaceholder = "메시지를 입력하세요"
    
    private let chatTrigger = PublishSubject<Void>()
    
    private let viewModel = ChannelChattingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        chatTrigger.onNext(())
    }
    
    override func bind() {
        super.bind()
        let input = ChannelChattingViewModel.Input(chatTrigger: chatTrigger)

        let output = viewModel.transform(input: input)
        
        output.chatList.bind(with: self) { owner, result in
            print(result)
        }
        .disposed(by: disposeBag)
        
        
    }
    
    override func setUI() {
        super.setUI()
        [chatGroupView, plusButton, textView, sendButton].forEach {
            view.addSubview($0)
        }
        
        chatGroupView.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.top.equalTo(textView.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(chatGroupView).offset(12)
            make.bottom.equalTo(chatGroupView.snp.bottom).inset(9)
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(18)
            make.bottom.equalTo(chatGroupView.snp.bottom).inset(10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(chatGroupView).inset(12)
            make.bottom.equalTo(chatGroupView.snp.bottom).inset(7)
            make.width.equalTo(24)
        }
        
    }
    
    
    override func setNav() {
        super.setNav()
      
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "Leading"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem

        let rightButton = UIBarButtonItem(image: UIImage(named: "list"), style: .plain, target: self, action: #selector(propertyButtonTapped))
        
        rightButton.tintColor = Colors.BrandBlack.CutsomColor
        
        self.navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = channelTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func propertyButtonTapped() {
        let vc = ChannelSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChannelChattingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceholder {
            textView.text = nil
            textView.textColor = Colors.TextPrimary.CutsomColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = Colors.TextSecondary.CutsomColor
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraint in
            
            if estimatedSize.height >= 54 {
                textView.isScrollEnabled = true
            } else {
                textView.isScrollEnabled = false
                constraint.constant = estimatedSize.height
            }
        }
    }
}
