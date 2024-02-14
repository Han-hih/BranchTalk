//
//  ChattingImageCollectionViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 2/14/24.
//

import UIKit

final class ChattingImageCollectionViewCell: UICollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
   private let deleteButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "deleteButton"), for: .normal)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    private func setUI() {
        [imageView, deleteButton].forEach {
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(-6)
            make.trailing.equalTo(imageView).offset(6)
            make.size.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

