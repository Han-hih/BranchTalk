//
//  FindChannelListTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 1/28/24.
//

import UIKit

class FindChannelListTableViewCell: UITableViewCell {
    
    private let hashImage = UIImageView(image: UIImage(named: "hashthick"))
    
    let channelName = {
        let lb = CustomBodyBoldLabel()
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        [hashImage, channelName].forEach {
            contentView.addSubview($0)
        }
        
        hashImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        channelName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(hashImage.snp.trailing).offset(16)
        }
    }
    
    func configure(name: String) {
        channelName.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
