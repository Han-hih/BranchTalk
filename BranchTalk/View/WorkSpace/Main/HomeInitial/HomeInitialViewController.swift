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
import Kingfisher

// 레이아웃
enum Section: Hashable, CaseIterable {
    case channel
    case dm
}
//셀
enum Item: Hashable {
    case channelList(GetChannel)
    case dmList(GetDmList)
}

final class HomeInitialViewController: BaseViewController, NetworkDelegate {
    
    func getWorkSpaceNetworkCall(id: Int) {
        print("-----------", id)
        UserDefaults.standard.set(id, forKey: "workSpaceID")
        channelTrigger.onNext(())
        dmTrigger.onNext(())
        getOneWorkSpaceList(id: id)
    }

    private lazy var tableView = {
        let view = UITableView()
        view.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        view.register(ChannelHeaderView.self, forHeaderFooterViewReuseIdentifier: ChannelHeaderView.identifier)
        view.register(ChannelFooterView.self, forHeaderFooterViewReuseIdentifier: ChannelFooterView.identifier)
        view.register(DmHeaderView.self, forHeaderFooterViewReuseIdentifier: DmHeaderView.identifier)
        view.register(DmTableViewCell.self, forCellReuseIdentifier: DmTableViewCell.identifier)
        view.register(DmFooterView.self, forHeaderFooterViewReuseIdentifier: DmFooterView.identifier)
        view.delegate = self
        view.rowHeight = 41
        view.sectionHeaderHeight = 56
        view.sectionFooterHeight = 41
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        view.separatorStyle = .none
        view.sectionHeaderTopPadding = 0
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
    private var arrowToggle:Bool = true
    
    private var dmExpandable: Bool = true
    private var dmArrowToggle: Bool = true
    
    private let viewModel = HomeInitialViewModel()
    
    private let channelTrigger = PublishSubject<Void>()
    private let dmTrigger = PublishSubject<Void>()
    
    private var channelList = [GetChannel]()
    private var dmList: [GetDmList] = []
    
    private let workSpaceID = UserDefaultsValue.shared.workSpaceID
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        getOneWorkSpaceList(id: workSpaceID)
        getProfile()
        swipeRecognizer()
        channelTrigger.onNext(())
        dmTrigger.onNext(())
        setDataSource()
    }
    
    func load() -> Data? {
        
        // 1. 불러올 파일 이름
        let fileNm: String = "mockTest"
        // 2. 불러올 파일의 확장자명
        let extensionType = "json"
        
        // 3. 파일 위치
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
        
        
        do {
            // 4. 해당 위치의 파일을 Data로 초기화하기
            let data = try Data(contentsOf: fileLocation)
            print(data)
          
            return data
        } catch {
            // 5. 잘못된 위치나 불가능한 파일 처리 (오늘은 따로 안하기)
            return nil
        }
    }
    override func bind() {
        super.bind()
        let input = HomeInitialViewModel.Input(channelTrigger: channelTrigger.asObservable(), dmTrigger: dmTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.channelList.bind(with: self) { owner, list in
            
            let items = list.map { Item.channelList($0) }
            //            owner.snapshot.appendSections(Section.allCases)
            owner.snapshot.appendItems(items.reversed(), toSection: .channel)
            
            owner.channelList = list.reversed()
            //            owner.dataSource?.apply(owner.snapshot)
        }
        .disposed(by: disposeBag)
        
        output.dmList.bind(with: self) { owner, list in
            
            let items = list.map { Item.dmList($0) }
            //            owner.snapshot.appendSections(Section.allCases)
            owner.snapshot.appendItems(items.reversed(), toSection: .dm)
            owner.dmList = list.reversed()
            //
            //            self.dataSource?.apply(owner.snapshot)
        }
        .disposed(by: disposeBag)
    }
    
    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, item in
            switch item {
            case .channelList(let list):
                let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell
                cell?.configure(channelName: list.name)
                return cell ?? UITableViewCell()
            case .dmList(let list):
                let cell = tableView.dequeueReusableCell(withIdentifier: DmTableViewCell.identifier, for: indexPath) as? DmTableViewCell
                cell?.configure(imageURL: list.user.profileImage, name: list.user.nickname)
                
                return cell ?? UITableViewCell()
            }
        })
        
        snapshot.appendSections(Section.allCases)
        
        if let jsonData = load() {
            if let jsonDatas = try? JSONDecoder().decode([GetDmList].self, from: jsonData) {
                print(jsonDatas)
                let itemList = jsonDatas.map { Item.dmList($0) }
                snapshot.appendItems(itemList, toSection: .dm)
            }
        }
        
        
       
        dataSource?.apply(snapshot)
        
    }
    
    private func getOneWorkSpaceList(id: Int) {
        NetworkManager.shared.request(type: WorkSpaceList.self, api: .getOneWorkSpaceList(id: id)) { [weak self] result in
            switch result {
            case .success(let response):
                let imageURL = response.thumbnail
                self?.setCustomNav(title: response.name, image: imageURL)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getProfile() {
        NetworkManager.shared.request(type: MyInfo.self, api: Router.getMyProfile) { result in
            switch result {
            case .success(let response):
                let image = response.profileImage
                self.setCustomProfile(image: image ?? "")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func setCustomNav(title: String, image: String) {
        let url = URL(string: image)
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 32, height: 32), mode: .aspectFill)
        navImageView.kf.setImage(with: url, options: [.requestModifier(KFModifier.shared.modifier), .processor(processor)])
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
        profileImageView.kf.setImage(with: URL(string: image), options: [.requestModifier(KFModifier.shared.modifier)])
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
                spaceImageTapped()
            default: break
            }
        }
    }
    
    override func setUI() {
        super.setUI()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
    
    @objc func makeWorkSpaceTapped() {
        
    }
    
    @objc func spaceImageTapped() {
        
        let vc = SideMenuViewController()
        vc.delegate = self
        
        let menu = HomeSideMenuNavigation(rootViewController: vc)
        present(menu, animated: true)
        
    }
    @objc func profileImageTapped() {
        
    }
    
    private func headerTapped() {
        
        if isExpandable {
            isExpandable = false
            arrowToggle = false
            
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .channel))
            
            //            snapshot.deleteSections([.channel])
            //            snapshot.appendSections([.channel])
                        tableView.footerView(forSection: 0)?.isHidden = true
            
            dataSource?.apply(snapshot)
            
            
        } else {
            isExpandable = true
            arrowToggle = true
            
            let items = channelList.map { Item.channelList($0) }
            snapshot.appendItems(items, toSection: .channel)
            
            dataSource?.apply(snapshot)
                        tableView.footerView(forSection: 0)?.isHidden = false
        }
        
    }
    
    private func dmHeaderTapped() {
        if dmExpandable {
            dmExpandable = false
            dmArrowToggle = false
            
            
            
            dataSource?.apply(snapshot)
            tableView.footerView(forSection: 0)?.isHidden = true
        } else {
            dmExpandable = true
            dmArrowToggle = true
            
            
            let items = dmList.map { Item.dmList($0) }
            snapshot.appendItems(items, toSection: .dm)
            
            dataSource?.apply(snapshot)
        }
    }
    
    private func footerTapped() {
        let actionsheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "채널 생성", style: .default, handler: { _ in
            print("채널 생성하기")
            let vc = AddChannelViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }))
        actionsheet.addAction(UIAlertAction(title: "채널 탐색", style: .default, handler: { _ in
            print("채널 탐색하기")
            let vc = FindChannelViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionsheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(actionsheet, animated: true)
    }
}

extension HomeInitialViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelHeaderView.identifier) as? ChannelHeaderView
            header?.arrowButton.setImage(UIImage(named: arrowToggle ? "right" : "down"), for: .normal)
            header?.setNeedsLayout()
            header?.layoutIfNeeded()
            let tapGesture = UITapGestureRecognizer()
            header?.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .asDriver()
                .drive(with: self) { owner, _ in
                    tableView.reloadData()
                    owner.headerTapped()
                }.disposed(by: disposeBag)
            return header
        } else if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DmHeaderView.identifier) as? DmHeaderView
            header?.arrowButton.setImage(UIImage(named: arrowToggle ? "right" : "down"), for: .normal)
            header?.setNeedsLayout()
            header?.layoutIfNeeded()
            let tapGesture = UITapGestureRecognizer()
            header?.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .asDriver()
                .drive(with: self) { owner, _ in
                    tableView.reloadData()
                    owner.dmHeaderTapped()
                }.disposed(by: disposeBag)
            return header
        } else { return UIView()}
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelFooterView.identifier) as? ChannelFooterView
            let tapGesture = UITapGestureRecognizer()
            footer?.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .asDriver()
                .drive(with: self) { owner, _ in
                    owner.footerTapped()
                }.disposed(by: disposeBag)
            return footer
        } else if section == 1 {
//            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DmFooterView.identifier) as? DmFooterView
//            return footer
            return UIView()
        }
        else { return UIView() }
    }
}
