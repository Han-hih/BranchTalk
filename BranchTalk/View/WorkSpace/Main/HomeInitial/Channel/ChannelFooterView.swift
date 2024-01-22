//
//  ChannelFooterView.swift
//  BranchTalk
//
//  Created by 황인호 on 1/21/24.
//

import UIKit

final class ChannelFooterView: UITableViewHeaderFooterView {
    
    private let footerTitle = {
        let lb = CustomBodyLabel()
        lb.text = "채널 추가"
        return lb
    }()
    
    private let plusButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "plus"), for: .normal)
        return bt
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        contentView.addSubview(plusButton)
        contentView.addSubview(footerTitle)
        
        footerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(plusButton.snp.trailing).offset(16)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
