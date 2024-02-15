//
//  ChannelChattingViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 2/1/24.
//

import UIKit
import RxSwift

final class ChannelChattingViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
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
    
    private lazy var imageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ChattingImageCollectionViewCell.self, forCellWithReuseIdentifier: ChattingImageCollectionViewCell.identifier)
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let stackView = {
        let st = UIStackView()
        st.spacing = 8
        st.distribution = .fill
        st.axis = .vertical
        return st
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
        [tableView, chatGroupView, plusButton, stackView, sendButton].forEach {
            view.addSubview($0)
        }
        
        [textView, imageCollectionView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(10)
            make.bottom.equalTo(chatGroupView.snp.top).offset(-16)
        }
        
        chatGroupView.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-12)
            make.top.equalTo(stackView.snp.top).offset(-10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(chatGroupView).offset(12)
            make.bottom.equalTo(chatGroupView.snp.bottom).inset(9)
            make.width.equalTo(22)
            make.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.bottom.equalTo(chatGroupView).inset(8)
            make.height.greaterThanOrEqualTo(18)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
            
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

extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell
        else { return UITableViewCell() }
        

        return cell
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
                textView.snp.remakeConstraints { make in
                    make.height.equalTo(54)
                }
            } else {
                textView.isScrollEnabled = false
                constraint.constant = estimatedSize.height
            }
        }
    }
}

extension ChannelChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ChattingImageCollectionViewCell.identifier, for: indexPath) as? ChattingImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (imageCollectionView.frame.width) / 6
        let height = width
        
        return CGSize(width: width, height: height)
    }
}
