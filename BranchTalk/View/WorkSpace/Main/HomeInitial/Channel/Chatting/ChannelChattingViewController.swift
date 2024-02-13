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
    
    private let textView = {
        let tv = UITextView()
        tv.backgroundColor = .red
        return tv
    }()
    
    private let sendButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "send"), for: .normal)
        return bt
    }()
    
    var channelTitle = ""
    
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
            make.bottom.equalTo(view.keyboardLayoutGuide).inset(32)
            make.height.greaterThanOrEqualTo(38)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(chatGroupView).offset(12)
            make.centerY.equalTo(chatGroupView)
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalTo(chatGroupView)
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(18)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(chatGroupView).inset(12)
            make.centerY.equalTo(chatGroupView)
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
    
    @objc func propertyButtonTapped() {
        let vc = ChannelSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
