//
//  ChannelTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 1/15/24.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    private let tagImage = {
        let view = UIImageView()
        view.image = UIImage(named: "hashthin")
        return view
    }()
    
    let channelLabel = {
        let lb = CustomBodyLabel()
        return lb
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }

    private func setUI() {
        [tagImage, channelLabel].forEach {
            contentView.addSubview($0)
        }
        
        contentView.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        
        tagImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.leading.equalToSuperview().offset(16)
        }
        
        channelLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(tagImage.snp.trailing).offset(16)
        }
        
        
    }
    
    func configure(channelName: String) {
        channelLabel.text = channelName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


