//
//  ChannelMemberHeaderView.swift
//  BranchTalk
//
//  Created by 황인호 on 2/7/24.
//

import UIKit

final class ChannelMemberHeaderView: UICollectionReusableView {
    
    static let id = "ChannelMemberHeaderView"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitle)
        addSubview(arrowButton)
        
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(title: String) {
        headerTitle.text = "멤버 (\(title))"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

