//
//  HomeInitialViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/11/24.
//

import UIKit
import SideMenu
import RxSwift
import RxCocoa

// 레이아웃
enum Section: Hashable {
    case channel
    case dm
}
//셀
enum Item: Hashable {
    case channelList(GetChannel)
    case dmList(GetDmList)
}

final class HomeInitialViewController: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        view.register(ChannelHeaderView.self, forHeaderFooterViewReuseIdentifier: ChannelHeaderView.identifier)
        view.register(ChannelFooterView.self, forHeaderFooterViewReuseIdentifier: ChannelFooterView.identifier)
        view.register(DmTableViewCell.self, forCellReuseIdentifier: DmTableViewCell.identifier)
        view.delegate = self
        view.rowHeight = 41
        view.separatorStyle = .none
        view.sectionHeaderHeight = 56
        view.sectionFooterHeight = 41
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        return view
    }()
    
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
    
    private var dataSource: UITableViewDiffableDataSource<Section,Item>?
    
    private var isExpandable: Bool = true
    
    private let viewModel = HomeInitialViewModel()
    
    private let channelTrigger = PublishSubject<Void>()
    private let dmTrigger = PublishSubject<Void>()
    
    private var channelList = [GetChannel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWorkSpaceList()
        getProfile()
        swipeRecognizer()
        channelTrigger.onNext(())
        dmTrigger.onNext(())
        setDataSource()
    }
    
    override func bind() {
        super.bind()
        let input = HomeInitialViewModel.Input(channelTrigger: channelTrigger.asObservable(), dmTrigger: dmTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.channelList.bind(with: self) { owner, list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            
            let items = list.map { Item.channelList($0) }
            snapshot.appendSections([.channel])
            snapshot.appendItems(items, toSection: .channel)
            owner.channelList.append(contentsOf: list)
            owner.dataSource?.apply(snapshot)
        }
        .disposed(by: disposeBag)
        
        output.dmList.bind(with: self) { owner, list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let items = list.map { Item.dmList($0) }
            snapshot.appendSections([.dm])
            snapshot.appendItems(items, toSection: .dm)
            
            self.dataSource?.apply(snapshot)
        }
        .disposed(by: disposeBag)
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .channelList(let list):
                let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell
                cell?.configure(channelName: list.name)
                return cell
            case .dmList(let list):
                let cell = tableView.dequeueReusableCell(withIdentifier: DmTableViewCell.identifier, for: indexPath) as? DmTableViewCell
                cell?.configure(imageURL: list.user.profileImage, name: list.user.nickname)
                return cell
            }
        })
        
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
    
    override func setUI() {
        super.setUI()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(160)
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
    
    private func headerTapped() {
        
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        
        if isExpandable {
            isExpandable = false
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.channel])
            
            dataSource?.apply(snapshot)
            
        } else {
            isExpandable = true
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.channel])
            dataSource?.apply(snapshot)
            
            let items = channelList.map { Item.channelList($0) }
            snapshot.appendItems(items, toSection: .channel)
            dataSource?.apply(snapshot)
        }
        
    }
}

extension HomeInitialViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelHeaderView.identifier) as? ChannelHeaderView
            let tapGesture = UITapGestureRecognizer()
            header?.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .asDriver()
                .drive(with: self) { owner, _ in
                    owner.headerTapped()
                }.disposed(by: disposeBag)
            
           return header
        } else { return UIView() }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return ChannelFooterView()
        } else { return UIView() }
    }
}
