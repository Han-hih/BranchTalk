//
//  CoinTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    let coinLabel = {
        let lb = CustomBodyBoldLabel()
        return lb
    }()
    
    
    let label = {
        let lb = CustomCaptionLabel()
        lb.text = "코인이란?"
        return lb
    }()
    
    let priceButton = {
        let bt = GreenCustonButton()
        bt.layer.cornerRadius = 4
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        [coinLabel, label, priceButton].forEach {
            contentView.addSubview($0)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(72)
            make.height.equalTo(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
