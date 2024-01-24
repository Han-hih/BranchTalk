//
//  DmTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 1/22/24.
//

import UIKit
import Kingfisher

class DmTableViewCell: UITableViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let dmName = {
        let lb = CustomBodyLabel()
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
  
    private func setUI() {
        [profileImage, dmName].forEach {
            contentView.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.size.equalTo(24)
        }
        
        dmName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
    }
    
    func configure(imageURL: String, name: String) {
        profileImage.kf.setImage(with: URL(string: imageURL))
        dmName.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
