//
//  StartWorkSpaceViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit

final class StartWorkSpaceViewController: BaseViewController {
    
   private let nickName = UserDefaults.value(forKey: "userID")
    
    private let topLabel = {
        let label = CustomTitle1Label()
        label.text = "출시 준비 완료!"
        return label
    }()
    
    private lazy var middleLabel = {
        let label = CustomBodyLabel()
        if let nickName = nickName {
            label.text = "\(nickName)님의 조직을 위해 새로운 새싹톡 워크스페이스를\n시작할 준비가 완료되었어요!"
        }
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var makeSpaceButton = {
        let bt = GreenCustonButton()
        bt.setTitle("워크스페이스 생성", for: .normal)
        bt.addTarget(self, action: #selector(makeSpaceTap), for: .touchUpInside)
        return bt
    }()
    
    private let imageView = UIImageView(image: UIImage(named: "launching"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundPrimary.CutsomColor
    }
    
    @objc func makeSpaceTap() {
        let vc = CreateWorkSpaceViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    override func setNav() {
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "시작하기"
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
        navigationBarAppearance.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    @objc func backButtonTapped() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let vc = HomeEmptyViewController()
        let nav = UINavigationController(rootViewController: vc)
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
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
}
