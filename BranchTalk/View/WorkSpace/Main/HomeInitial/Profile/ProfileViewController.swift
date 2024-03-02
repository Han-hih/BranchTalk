//
//  ProfileViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import UIKit
import Alamofire

final class ProfileViewController: BaseViewController {
    
    private let profileView = ProfileView()
    private let viewModel = CoinShopViewModel()
    
    
    var email: String? = nil
    var call: String? = nil
    var nick: String? = nil
    var myCoin: Int? = nil
    
    override func loadView() {
        self.view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network()
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileView.tableView.reloadData()
    }
    
    func network() {
        NetworkManager.shared.refreshRequest(type: MyInfo.self, api: .getMyProfile) { result in
            switch result {
            case .success(let response):
                let url = URL(string: response.profileImage ?? "")
                self.profileView.profileImage.kf.setImage(with: url, options: [.requestModifier(KFModifier.shared.modifier)])
                self.nick = response.nickname
                self.call = response.phone
                self.email = response.email
                self.myCoin = response.sesacCoin
                self.profileView.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func setNav() {
        super.setNav()
     
            let backButtonItem = UIBarButtonItem(image: UIImage(named: "Leading"), style: .plain, target: self, action: #selector(backButtonTapped))
            
            backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
            self.navigationItem.leftBarButtonItem = backButtonItem
            
            navigationItem.title = "내 정보 수정"
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
    }
    
 
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
             return 3
        } else { return 2}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let text = "내 새싹 코인 \(myCoin ?? 0)개"
                cell.label.textColor = Colors.BrandGreen.CutsomColor
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(.foregroundColor, value: Colors.TextPrimary.CutsomColor, range: (text as NSString).range(of: "내 새싹 코인"))
                            
                cell.label.attributedText = attributedString
                cell.bodyLabel.text = "충전하기"
                
            }
            if indexPath.row == 1 {
                cell.label.text = "닉네임"
                cell.bodyLabel.text = nick
            }
            if indexPath.row == 2 {
                cell.label.text = "연락처"
                cell.bodyLabel.text = call
            }
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.label.text = "이메일"
                cell.accessoryType = .none
                cell.bodyLabel.text = email
            }
            if indexPath.row == 1 {
                cell.label.text = "로그아웃"
                cell.accessoryType = .none
                cell.label.textColor = Colors.TextPrimary.CutsomColor
                cell.bodyLabel.text = ""
            }
            if indexPath.row == 2 {
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = CoinShopViewConroller()
            vc.coin = myCoin
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
