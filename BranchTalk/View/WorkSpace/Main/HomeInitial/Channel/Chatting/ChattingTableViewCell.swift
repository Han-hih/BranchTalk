//
//  ChattingTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 2/13/24.
//

import UIKit
import Kingfisher

final class ChattingTableViewCell: UITableViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let stackView = {
        let st = UIStackView()
        st.alignment = .leading
        st.distribution = .fill
        st.spacing = 5
        st.axis = .vertical
        return st
    }()
    
    let nameLabel = {
        let lb = CustomCaptionLabel()
        lb.text = "블루베리"
        return lb
    }()
    
    lazy var speechBubble = {
        let lb = BasePaddingLabel()
        lb.text = "안녕하세요. 반갑습니다"
        lb.font = Font.body()
        lb.clipsToBounds = true
        lb.layer.cornerRadius = 8
        lb.layer.borderWidth = 1
        lb.layer.borderColor = Colors.BrandInactive.CutsomColor.cgColor
        lb.sizeToFit()
        lb.numberOfLines = 0
        return lb
    }()
    
    let imageStackView = {
        let st = UIStackView()
        st.distribution = .equalSpacing
        st.alignment = .top
        st.spacing = 2
        st.axis = .vertical
        st.layer.cornerRadius = 12
        st.clipsToBounds = true
        return st
    }()
    
    let firstSectionStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.spacing = 2
        st.axis = .horizontal
        return st
    }()
    
    let secondSectionStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.spacing = 2
        st.axis = .horizontal
        return st
    }()
    
    let firstChatImage = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let secondChatImage = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let thirdChatImage = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let fourthChatImage = {
        let view = UIImageView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    let fifthChatImage = {
        let view = UIImageView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    
    let timeLabel = {
        let lb = CustomCaptionLabel()
        lb.font = Font.caption2()
        lb.textColor = Colors.TextSecondary.CutsomColor
        lb.numberOfLines = 0
        lb.text = "03:12 오전"
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        speechBubble.isHidden = false
        self.firstChatImage.isHidden = false
        self.secondChatImage.isHidden = false
        self.thirdChatImage.isHidden = false
        self.fourthChatImage.isHidden = false
        self.fifthChatImage.isHidden = false
        self.firstSectionStackView.isHidden = false
        self.secondSectionStackView.isHidden = false
        self.imageStackView.isHidden = false
        firstSectionStackView.snp.remakeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(contentView).multipliedBy(0.7)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
        }
    }

    
    private func setUI() {
        [profileImage, stackView, nameLabel, timeLabel].forEach {
            contentView.addSubview($0)
        }
        [speechBubble, imageStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [firstSectionStackView, secondSectionStackView].forEach {
            imageStackView.addArrangedSubview($0)
        }
        
        [firstChatImage, secondChatImage, thirdChatImage].forEach {
            firstSectionStackView.addArrangedSubview($0)
        }
        
        [fourthChatImage, fifthChatImage].forEach {
            secondSectionStackView.addArrangedSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(34)
            make.top.equalTo(contentView).offset(6)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(6)
            make.top.equalTo(profileImage)
        }
        
        speechBubble.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(34)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(6)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.height.greaterThanOrEqualTo(34)
            make.bottom.equalTo(contentView).inset(6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(4)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        firstSectionStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.lessThanOrEqualTo(contentView.snp.width).multipliedBy(0.7)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            make.height.equalTo(80)
        }
        
        secondSectionStackView.snp.makeConstraints { make in
            make.leading.equalTo(firstSectionStackView)
            make.width.equalTo(firstSectionStackView)
            make.trailing.equalTo(firstSectionStackView)
            make.height.equalTo(80)
        }
    }
    
    func configure(profile: String, name: String, chat: String, time: Date) {
        let url = URL(string: profile)
        profileImage.kf.setImage(with: url, options: [.requestModifier(KFModifier.shared.modifier)])
        nameLabel.text = name
        if chat == "" {
            speechBubble.isHidden = true
        } else {
            speechBubble.text = chat
        }
        
        let chatTime = time
        let currentDate = Date()
        
       if Calendar.current.isDate(chatTime, inSameDayAs: currentDate) {
           timeLabel.text = dateString(from: time, format: "hh:mm a")
       } else {
           timeLabel.text = dateString(from: time, format: "MM/dd\nhh:mm a")
       }
        
    }
    
    func dateString(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
 
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    func imageLayout(_ image: [String]) {
        
        var urlArray: [String] = []
        
        for num in 0..<image.count {
            urlArray.append(image[num])
        }
        
        if image.count == 0 {
            imageStackView.isHidden = true
        }
        
        if image.count == 1 {
            firstChatImage.kf.setImage(with: URL(string: urlArray[0]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondSectionStackView.isHidden = true
            secondChatImage.isHidden = true
            thirdChatImage.isHidden = true
            firstSectionStackView.snp.remakeConstraints { make in
                make.height.equalTo(160)
                make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
                make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            }
        }
        
        if image.count == 2 {
            firstChatImage.kf.setImage(with: URL(string: urlArray[0]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondChatImage.kf.setImage(with: URL(string: urlArray[1]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondSectionStackView.isHidden = true
            thirdChatImage.isHidden = true
        }
        
        if image.count == 3 {
            firstChatImage.kf.setImage(with: URL(string: urlArray[0]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondChatImage.kf.setImage(with: URL(string: urlArray[1]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            thirdChatImage.kf.setImage(with: URL(string: urlArray[2]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondSectionStackView.isHidden = true
        }
        
        if image.count == 4 {
            firstChatImage.kf.setImage(with: URL(string: urlArray[0]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondChatImage.kf.setImage(with: URL(string: urlArray[1]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            thirdChatImage.kf.setImage(with: URL(string: urlArray[2]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            fourthChatImage.kf.setImage(with: URL(string: urlArray[3]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            thirdChatImage.isHidden = true
        }
        
        if image.count == 5 {
            firstChatImage.kf.setImage(with: URL(string: urlArray[0]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            secondChatImage.kf.setImage(with: URL(string: urlArray[1]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            thirdChatImage.kf.setImage(with: URL(string: urlArray[2]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            fourthChatImage.kf.setImage(with: URL(string: urlArray[3]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
            fifthChatImage.kf.setImage(with: URL(string: urlArray[4]), placeholder: UIImage(), options: [.cacheOriginalImage, .requestModifier(KFModifier.shared.modifier)])
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
