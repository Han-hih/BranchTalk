//
//  SideMenuViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/13/24.
//

import UIKit
import Kingfisher

protocol NetworkDelegate: AnyObject {
    func getWorkSpaceNetworkCall(id: Int)
}

class SideMenuViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.rowHeight = 72
        view.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var appendWorkSpaceButton = {
        let bt = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "plus")
        configuration.baseForegroundColor = Colors.TextSecondary.CutsomColor
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.imagePadding = 16
        var attributedText = AttributedString("워크스페이스 추가")
        attributedText.font = Font.body()
        attributedText.foregroundColor = Colors.TextSecondary.CutsomColor
        configuration.attributedTitle = attributedText
        bt.configuration = configuration
        bt.addTarget(self, action: #selector(appendWorkSpaceButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private let helpButton = {
        let bt = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: "help")
        configuration.baseForegroundColor = Colors.TextSecondary.CutsomColor
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18)
        configuration.imagePadding = 16
        var attributedText = AttributedString("도움말")
        attributedText.font = Font.body()
        attributedText.foregroundColor = Colors.TextSecondary.CutsomColor
        configuration.attributedTitle = attributedText
        bt.configuration = configuration
        return bt
    }()
    
    private var workSpaceResult = [WorkSpaceList]()
    
    var delegate: NetworkDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        self.view.layer.cornerRadius = 25
        self.view.clipsToBounds = true
        getWorkList()
        
    }
    
    private func getWorkList() {
        NetworkManager.shared.refreshRequest(type: [WorkSpaceList].self, api: .getWorkSpaceList) { result in
            switch result {
            case .success(let success):
                self.workSpaceResult.append(contentsOf: success)
                self.tableView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @objc func appendWorkSpaceButtonTapped() {
        let vc = CreateWorkSpaceViewController()
        present(vc, animated: true)
    }
    
    override func setUI() {
        [tableView, appendWorkSpaceButton, helpButton].forEach {
            view.addSubview($0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(appendWorkSpaceButton.snp.top)
        }
        
        appendWorkSpaceButton.snp.makeConstraints { make in
            make.bottom.equalTo(helpButton.snp.top)
            make.height.equalTo(41)
            make.leading.equalToSuperview()
        }
        
        helpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview()
            make.height.equalTo(41)
        }
    }
    
    override func setNav() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        lazy var spaceName = UIBarButtonItem(title: "워크스페이스", style: .done, target: self, action: nil)
        spaceName.isSelected = false
        spaceName.setTitleTextAttributes([NSAttributedString.Key.font: Font.title1Bold(),
                                          NSAttributedString.Key.foregroundColor: Colors.BrandBlack.CutsomColor], for: .normal)
        
        navigationItem.leftBarButtonItems = [spaceName]
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workSpaceResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath) as? SideMenuTableViewCell else { return UITableViewCell() }
        
        let imageURL = workSpaceResult[indexPath.row].thumbnail
        
        cell.configure(image: imageURL, text: workSpaceResult[indexPath.row].name, secondText: workSpaceResult[indexPath.row].createdAt)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
    
        cell.contentView.backgroundColor = Colors.BackgroundPrimary.CutsomColor
        
        let id = workSpaceResult[indexPath.row].workspaceID
        
        delegate?.getWorkSpaceNetworkCall(id: id)
    
        dismiss(animated: true)
    }
}

