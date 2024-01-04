//
//  HomeViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit

final class HomeEmptyViewController: BaseViewController {
    
    private let topLabel = {
        let label = CustomTitle1Label()
        label.text = "워크스페이스를 찾을 수 없어요"
        return label
    }()
    
    private lazy var middleLabel = {
        let label = CustomBodyLabel()
        label.text = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var makeSpaceButton = {
        let bt = GreenCustonButton()
        bt.setTitle("워크스페이스 생성", for: .normal)
        return bt
    }()
    
    private let imageView = UIImageView(image: UIImage(named: "workspaceempty"))
    
    private let navImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let profileImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
        view.backgroundColor = .green
        return view
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUI() {
        super.setUI()
        [topLabel, middleLabel, imageView, makeSpaceButton].forEach {
            view.addSubview($0)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.centerX.equalTo(view)
        }
        middleLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(24)
            make.centerX.equalTo(view)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalToSuperview().inset(12)
            make.height.equalTo(imageView.snp.width)
        }
        
        makeSpaceButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    override func setNav() {
        super.setNav()
        let spaceImage = UIBarButtonItem(customView: navImageView)
        lazy var spaceName = UIBarButtonItem(title: "No Workspace", style: .plain, target: self, action: #selector(spaceImageTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8
        
        spaceName.setTitleTextAttributes([NSAttributedString.Key.font: Font.title1Bold(),
                                          NSAttributedString.Key.foregroundColor: Colors.BrandBlack.CutsomColor], for: .normal)
        
        let profileImage = UIBarButtonItem(customView: profileImageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
                profileImageView.isUserInteractionEnabled = true
                profileImageView.addGestureRecognizer(tapGestureRecognizer)

        navigationItem.leftBarButtonItems = [spaceImage, spacer, spaceName]
        navigationItem.rightBarButtonItem = profileImage
    }
    
    @objc func profileImageTapped() {
        print("프로필 눌림")
    }
    
    @objc func spaceImageTapped() {
        print("눌림")
    }
}
