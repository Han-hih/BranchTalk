//
//  ProfileView.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    
    let profileImage = {
        let view = UIImageView()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let cameraButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "Camera"), for: .normal)
        return bt
    }()
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        view.rowHeight = 44
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        view.separatorStyle = .none
       return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    private func setUI() {
        [profileImage, cameraButton, tableView].forEach {
            self.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.size.equalTo(70)
            make.centerX.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalTo(profileImage.snp.trailing).offset(7)
            make.bottom.equalTo(profileImage.snp.bottom).offset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(35)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
