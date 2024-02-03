//
//  FindChannelViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/28/24.
//

import UIKit
import RxSwift

final class FindChannelViewController: BaseViewController {
 
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(FindChannelListTableViewCell.self, forCellReuseIdentifier: FindChannelListTableViewCell.identifier)
        view.rowHeight = 41
        view.separatorStyle = .none
        return view
    }()
    
    private let viewModel = FindChannelViewModel()
    
    private let channelTrigger = PublishSubject<Void>()
    
    private var channelList = [GetChannel]()
    
    private var channelTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelTrigger.onNext(())
    }
 
    override func bind() {
        super.bind()
        let input = FindChannelViewModel.Input(channelTrigger: channelTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.channelList.bind(with: self) { owner, list in
            owner.channelList = list.reversed().filter { $0.name != "일반" }
            owner.tableView.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    override func setNav() {
        super.setNav()
        let backButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(backButtonTapped))
        backButtonItem.tintColor = Colors.BrandBlack.CutsomColor
        self.navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = "채널 탐색"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font.navTitle()]
        self.navigationController?.navigationBar.backgroundColor = Colors.BackgroundSecondary.CutsomColor
    }
    
    override func setUI() {
        super.setUI()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension FindChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindChannelListTableViewCell.identifier, for: indexPath) as? FindChannelListTableViewCell else { return UITableViewCell() }
        cell.configure(name: channelList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let notEngagedChannel = channelList.filter { !viewModel.myChannel.contains($0) }
        
        if notEngagedChannel.contains(channelList[indexPath.row]) {
            print("참여 안 된 채널")
            self.channelTitle = channelList[indexPath.row].name
            show(alertType: .canCancel, alertText: "채널 참여", descText: "[\(channelList[indexPath.row].name)] 채널에 참여하시겠습니까?", confirmButtonText: "확인")
            UserDefaults.standard.setValue(channelList[indexPath.row].channelID, forKey: "channelID")
            UserDefaults.standard.setValue(channelList[indexPath.row].name, forKey: "channelName")
            
        } else {
            print("이미 참여한 채널")
            let vc = ChannelChattingViewController()
            vc.channelTitle = channelList[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FindChannelViewController: CustomAlertDelegate {
    func confirm() {
        let vc = ChannelChattingViewController()
        vc.channelTitle = channelTitle
        navigationController?.pushViewController(vc, animated: true)
    }
}
