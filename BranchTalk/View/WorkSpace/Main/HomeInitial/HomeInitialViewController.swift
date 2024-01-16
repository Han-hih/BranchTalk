//
//  HomeInitialViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/11/24.
//

import UIKit
import SideMenu

// 레이아웃
enum Section: Hashable {
    case channel
    case dm
}
//셀
enum Item: Hashable {
    case channelList
    case messageList
}



final class HomeInitialViewController: BaseViewController {
    
    private lazy var makeSpaceButton = {
        let bt = GreenCustonButton()
        bt.setTitle("워크스페이스 생성", for: .normal)
        bt.addTarget(self, action: #selector(makeWorkSpaceTapped), for: .touchUpInside)
        return bt
    }()
    
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
        getWorkSpaceList()
        getProfile()
        swipeRecognizer()
    }
    
    private func getWorkSpaceList() {
        NetworkManager.shared.request(type: GetWorkSpaceList.self, api: Router.getWorkSpaceList) { [weak self] result in
            switch result {
            case .success(let response):
                let imageURL = APIKey.baseURL + "/v1" + response[0].thumbnail
                self?.setCustomNav(title: response[0].name, image: imageURL)
                print(imageURL)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getProfile() {
        NetworkManager.shared.request(type: MyInfo.self, api: Router.getMyProfile) { result in
            switch result {
            case .success(let response):
                let image = APIKey.baseURL + (response.profileImage ?? "")
                self.setCustomProfile(image: image)
                print(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func setCustomNav(title: String, image: String) {
        navImageView.kf.setImage(with: URL(string: image))
        lazy var spaceImage = UIBarButtonItem(customView: navImageView)
        lazy var spaceName = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(spaceImageTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 8
        
        spaceName.setTitleTextAttributes([NSAttributedString.Key.font: Font.title1Bold(),
                                          NSAttributedString.Key.foregroundColor: Colors.BrandBlack.CutsomColor], for: .normal)
        
        navigationItem.leftBarButtonItems = [spaceImage, spacer, spaceName]
        
    }
    
    private func setCustomProfile(image: String) {
        let profileImage = UIBarButtonItem(customView: profileImageView)
        profileImageView.kf.setImage(with: URL(string: image))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        navigationItem.rightBarButtonItem = profileImage
    }
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizer.Direction.right:
                let menu = HomeSideMenuNavigation(rootViewController: SideMenuViewController())
                present(menu, animated: true)
            default: break
            }
        }
    }
    
    @objc func makeWorkSpaceTapped() {
     
    }
    
    @objc func spaceImageTapped() {
        let menu = HomeSideMenuNavigation(rootViewController: SideMenuViewController())
        present(menu, animated: true)
        
    }
    @objc func profileImageTapped() {
        
    }
    
    private func showSlideMenu() {
        
    }
}
