//
//  ChannelHeaderView.swift
//  BranchTalk
//
//  Created by 황인호 on 1/19/24.
//

import UIKit

final class ChannelHeaderView: UITableViewHeaderFooterView {
    
    private let headerTitle = {
        let lb = CustomTitle2Label()
        lb.text = "채널"
        return lb
    }()
    
    var arrowButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "down"), for: .normal)
        return bt
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerTitle)
        contentView.addSubview(arrowButton)
        
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
