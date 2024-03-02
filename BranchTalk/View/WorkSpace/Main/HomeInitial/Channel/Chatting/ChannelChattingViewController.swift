//
//  ChannelChattingViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 2/1/24.
//

import UIKit
import RxSwift
import PhotosUI

final class ChannelChattingViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private let chatGroupView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        return view
    }()
    
    private lazy var plusButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "plus"), for: .normal)
        bt.addTarget(self, action: #selector(openPhpicker), for: .touchUpInside)
        return bt
    }()
    
    private lazy var textView = {
        let tv = UITextView()
        tv.text = textViewPlaceholder
        tv.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        tv.textColor = Colors.TextPrimary.CutsomColor
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
    
    lazy var imageCollectionView = {
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
    private let sendChatTrigger = PublishSubject<Void>()
    
    private let imageCountValue = BehaviorSubject(value: 0)
    
    private let imageData = BehaviorSubject(value: [Data]())
    
    private let viewModel = ChannelChattingViewModel()
    
    private var imageArray = [UIImage]()
    
    private var itemProviders: [NSItemProvider] = []
    
    private var selections = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    private var chatTasks: [ChatDetailTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        chatTrigger.onNext(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.disconnectSocket()
    }
    
    
    func scrollToBottom(){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatTasks.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    
    override func bind() {
        super.bind()
        
        let input = ChannelChattingViewModel.Input(
            chatTrigger: chatTrigger,
            contentInputValid: textView.rx.text.orEmpty.asObservable(),
            imageInputValid: imageCountValue.asObservable(),
            chatImage: imageData.asObservable(),
            sendMessage: sendButton.rx.tap.asObservable()
            )
        
        let output = viewModel.transform(input: input)
        
        output.chatList.bind(with: self) { owner, result in
            owner.chatTasks = result
            owner.imageCollectionView.isHidden = true
            owner.scrollToBottom()
        }
        .disposed(by: disposeBag)
        
        // 처음에 불러오고 추가적으로는 원래 있던 테이블뷰 배열에다가 추가만 해줌
        output.sendMessage
            .bind(with: self) { owner, value in
                owner.chatTasks.append(value[0])
                owner.tableView.reloadData()
                owner.imageCollectionView.isHidden = true
                owner.selectedAssetIdentifiers = []
                owner.selections = [String: PHPickerResult]()
                SocketIOManager.shared.connectSocket(channelID: UserDefaults.standard.integer(forKey: "channelID"))
                owner.scrollToBottom()
            }
            .disposed(by: disposeBag)
        
        output.appendChatList
            .bind(with: self) { owner, result in
                owner.tableView.reloadData()
                owner.scrollToBottom()
                owner.textView.text = ""
                owner.imageArray.removeAll()
                owner.selectedAssetIdentifiers = []
                owner.selections = [String: PHPickerResult]()
                owner.imageCollectionView.isHidden = true
               
            }
            .disposed(by: disposeBag)
        
        output.chatInputValid
            .asDriver()
            .drive(with: self, onNext: { owner, bool in
                if owner.textView.textColor != Colors.TextSecondary.CutsomColor || self.imageArray.count != 0 {
                    owner.sendButton.setImage(UIImage(named: bool ? "sendactive" : "send"), for: .normal)
                    owner.sendButton.isEnabled = bool ? true : false
                }

            })
        .disposed(by: disposeBag)
        
        
        
        output.receiveMessage
            .bind(with: self) { owner, value in
                print("💪", value)
                owner.chatTasks.append(value)
                owner.tableView.reloadData()
//                owner.selectedAssetIdentifiers = []
//                owner.imageCollectionView.isHidden = true
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
    
    @objc func openPhpicker() {
        presentPicker()
    }
}

extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.identifier, for: indexPath) as? ChattingTableViewCell
        else { return UITableViewCell() }

        let chat = chatTasks[indexPath.row]
        
        cell.configure(
            profile: chat.user?.userImage ?? "",
            name: chat.user?.userName ?? "",
            chat: chat.chatText ?? "",
            time: chat.time
        )
      
        let images: [String] = chat.chatFiles.map { $0 }
        if images.count == 0 {
            cell.firstSectionStackView.isHidden = true
            cell.secondSectionStackView.isHidden = true
            cell.imageStackView.isHidden = true
        } else {
            cell.firstSectionStackView.isHidden = false
            cell.secondSectionStackView.isHidden = false
            cell.imageStackView.isHidden = false
            cell.imageLayout(images)
            
        }
        
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
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ChattingImageCollectionViewCell.identifier, for: indexPath) as? ChattingImageCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = imageArray[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? ChattingImageCollectionViewCell else { return }
        guard let indexPath = imageCollectionView.indexPath(for: cell) else { return }
        imageArray.remove(at: sender.tag)
        print(imageArray)
        self.imageCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (imageCollectionView.frame.width) / 6
        let height = width
        
        return CGSize(width: width, height: height)
    }
}

extension ChannelChattingViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        
        var newSelected = [String: PHPickerResult]()
        
        for result in results {
            guard let identifier = result.assetIdentifier else { return }
            newSelected[identifier] = selections[identifier] ?? result
        }
        selections = newSelected
        
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        
        if itemProviders.isEmpty {
            imageArray.removeAll()
        } else {
            displayImage()
        }
        
        
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String: UIImage]()
        
        for (identifier, result) in selections {
            dispatchGroup.enter()
            
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            imagesDict[identifier] = image
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else { return }
                
                imageArray.removeAll()
                
                var imageDataArray: [Data] = []
                
                for identifier in self.selectedAssetIdentifiers {
                    guard let image = imagesDict[identifier] else { return }
                    imageArray.append(image)
                    imageDataArray.append(image.jpegData(compressionQuality: 0.3) ?? Data())
                }
                imageData.onNext(imageDataArray)
                imageCountValue.onNext(imageDataArray.count)
                if textView.textColor == Colors.TextSecondary.CutsomColor {
                    textView.text = ""
                }
                imageCollectionView.isHidden = false
                imageCollectionView.reloadData()
            }
            
        }
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 5
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
}
