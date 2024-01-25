//
//  SideMenuTableViewCell.swift
//  BranchTalk
//
//  Created by 황인호 on 1/14/24.
//

import UIKit
import Kingfisher

class SideMenuTableViewCell: UITableViewCell {

    let spaceImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let titleTextLabel = {
        let lb = CustomBodyBoldLabel()
        return lb
    }()
    
    let secondTextLabel = {
        let lb = CustomBodyLabel()
        return lb
    }()
    
    let dotButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "three dots"), for: .normal)
        bt.tintColor = Colors.BrandBlack.CutsomColor
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
    }
    private func setUI() {
        
        [spaceImage, titleTextLabel, secondTextLabel, dotButton].forEach {
            contentView.addSubview($0)
        }
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        
        spaceImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        titleTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(spaceImage.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(12)
        }
        
        secondTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleTextLabel.snp.leading)
            make.top.equalTo(titleTextLabel.snp.bottom)
        }
        
        dotButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
     func configure(image: String, text: String, secondText: String) {
        spaceImage.kf.setImage(with: URL(string: image), options: [.requestModifier(KFModifier.shared.modifier)])
        titleTextLabel.text = text
        secondTextLabel.text = secondText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
