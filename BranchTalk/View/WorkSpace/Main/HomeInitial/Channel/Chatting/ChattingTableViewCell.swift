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
        st.distribution = .fillProportionally
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
        st.distribution = .fill
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
        return view
    }()
    let secondChatImage = {
        let view = UIImageView()
        view.backgroundColor = .black
        return view
    }()
    let thirdChatImage = {
        let view = UIImageView()
        view.backgroundColor = .yellow
        return view
    }()
    let fourthChatImage = {
        let view = UIImageView()
        view.backgroundColor = .blue
        return view
    }()
    let fifthChatImage = {
        let view = UIImageView()
        view.backgroundColor = .brown
        return view
    }()
    
    
    let timeLabel = {
        let lb = CustomCaptionLabel()
        lb.font = Font.caption2()
        lb.textColor = Colors.TextSecondary.CutsomColor
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
        //        self.chatImageView.image = nil
        self.nameLabel.text = nil
        self.speechBubble.text = nil
    }
    
    private func setUI() {
        [profileImage, stackView, timeLabel].forEach {
            contentView.addSubview($0)
        }
        [nameLabel, speechBubble, imageStackView].forEach {
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
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(6)
            make.top.equalTo(contentView).offset(6)
            
            make.height.greaterThanOrEqualTo(50)
            make.bottom.equalTo(contentView).inset(6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(160)
        }
        
        firstSectionStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
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
    
    func configure(profile: String, name: String, chat: String, time: String) {
        let url = URL(string: profile)
        profileImage.kf.setImage(with: url)
        nameLabel.text = name
        speechBubble.text = chat
        timeLabel.text = time
    }
    
    func imageLayout(_ image: [String]) {
        if image.count == 0 {
            imageStackView.isHidden = true
        }
        
        if image.count == 1 {
            firstSectionStackView.isHidden = true
            secondSectionStackView.isHidden = true
            imageStackView.addArrangedSubview(firstChatImage)
            imageStackView.snp.remakeConstraints { make in
                make.height.equalTo(160)
            }
        }
        
        if image.count == 2 {
            secondSectionStackView.isHidden = true
            thirdChatImage.isHidden = true
        }
        
        if image.count == 3 {
            secondSectionStackView.isHidden = true
        }
        
        if image.count == 4 {
            thirdChatImage.isHidden = true
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
