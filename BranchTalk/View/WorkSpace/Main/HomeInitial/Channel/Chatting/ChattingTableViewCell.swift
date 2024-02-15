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
    
    let speechBubble = {
        let lb = BasePaddingLabel()
        lb.text = "안녕하세요. 반갑습니다"
        lb.font = Font.body()
        lb.clipsToBounds = true
        lb.layer.cornerRadius = 8
        lb.layer.borderWidth = 1
        lb.layer.borderColor = Colors.BrandInactive.CutsomColor.cgColor
        lb.numberOfLines = 0
        return lb
    }()
    
    let chatImageView = {
        let view = UIImageView()
        
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
        self.chatImageView.image = nil
        self.nameLabel.text = nil
        self.speechBubble.text = nil
    }
    
    private func setUI() {
        [profileImage, stackView, timeLabel].forEach {
            contentView.addSubview($0)
        }
        [nameLabel, speechBubble, chatImageView].forEach {
            stackView.addArrangedSubview($0)
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
        
        speechBubble.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(stackView.snp.bottom)
        }
    }
    
    func configure(profile: String, name: String, chat: String, time: String) {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
