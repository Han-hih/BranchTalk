//
//  RegisterViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/3/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        setNavigation()
    }
    
    private func setNavigation() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
       
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }
    
    @objc func backButtonTapped() {
        print("뒤로가기 버튼 탭")
    }
}
