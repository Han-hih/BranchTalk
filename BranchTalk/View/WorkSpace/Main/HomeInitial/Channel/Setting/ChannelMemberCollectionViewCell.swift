//
//  ChannelMemeberCollectionViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 2/4/24.
//

import UIKit

final class ChannelMemberCollectionViewCell: UICollectionViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    let nameLabel = {
        let lb = CustomBodyLabel()
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImage)
        self.addSubview(nameLabel)
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.horizontalEdges.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(profileImage)
            make.top.equalTo(profileImage.snp.bottom).offset(4)
           
        }
    }
    
    func configure(image: String?, name: String) {
        profileImage.kf.setImage(with: URL(string: image ?? ""))
        nameLabel.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
