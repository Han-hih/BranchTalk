//
//  ChannelChattingViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 2/1/24.
//

import UIKit
import RxSwift

final class ChannelChattingViewController: BaseViewController {
    
    var channelTitle = ""
    
    private let chatTrigger = PublishSubject<Void>()
    
    private let viewModel = ChannelChattingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
