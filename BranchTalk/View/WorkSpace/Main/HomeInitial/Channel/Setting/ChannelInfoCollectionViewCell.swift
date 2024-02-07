//
//  ChannelInfoCollectionViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 2/4/24.
//

import UIKit

final class ChannelInfoCollectionViewCell: UICollectionViewCell {

    let titleLabel = {
        let lb = CustomTitle2Label()
        return lb
    }()
    
    let descLabel = {
        let lb = CustomBodyLabel()
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [titleLabel, descLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, desc: String?) {
        titleLabel.text = title
        descLabel.text = desc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
