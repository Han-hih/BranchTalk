//
//  ProfileTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    
     let label = {
        let lb = CustomBodyBoldLabel()
        
        return lb
    }()
    
    let bodyLabel = {
        let lb = CustomBodyLabel()
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        [label, bodyLabel].forEach{
            contentView.addSubview($0)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(contentView.snp.trailing).inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
