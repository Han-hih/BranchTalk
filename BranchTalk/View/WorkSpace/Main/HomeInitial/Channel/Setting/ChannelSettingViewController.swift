//
//  ChannelSettingView.swift
//  BranchTalk
//
//  Created by 황인호 on 2/3/24.
//

import UIKit
import RxSwift

enum SettingSection: Hashable {
    case channelInfo
    case memberInfo
}

enum SettingItem: Hashable {
    case channelInfo(ChannelInfo)
    case memberInfo(ChannelMembers)
}

final class ChannelSettingViewController: BaseViewController {
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: view.bounds, collectionViewLayout: self.createLayout())
        view.register(ChannelInfoCollectionViewCell.self, forCellWithReuseIdentifier: ChannelInfoCollectionViewCell.identifier)
        view.register(ChannelMemberCollectionViewCell.self, forCellWithReuseIdentifier: ChannelMemberCollectionViewCell.identifier)
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SettingSection, SettingItem>?
    
    private let viewModel = ChannelSettingViewModel()
    
    private let chatTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTrigger.onNext(())
        setDataSource()
    }
    
    override func bind() {
        super.bind()
        let input = ChannelSettingViewModel.Input(settingTrigger: chatTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.settingTrigger
            .bind(with: self) { owner, result in
                var snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingItem>()
                
                let firstSectionItem = [SettingItem.channelInfo(result)]
                snapshot.appendSections([.channelInfo])
                snapshot.appendItems(firstSectionItem, toSection: .channelInfo)
                
                let secondSectionItem = result.channelMembers.map { SettingItem.memberInfo($0) }
                snapshot.appendSections([.memberInfo])
                snapshot.appendItems(secondSectionItem)
                
                owner.dataSource?.apply(snapshot)
            }
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = .zero
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .channelInfo:
                return self?.createInfoSection()
            case .memberInfo:
                return self?.createMemberSection()
            case .none:
                return nil
            }
        }, configuration: config)
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(18))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(18))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createMemberSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 5)
    
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SettingSection, SettingItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .channelInfo(let channelData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelInfoCollectionViewCell.identifier, for: indexPath) as? ChannelInfoCollectionViewCell
                cell?.configure(title: channelData.name, desc: "ㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎㅎ")
                return cell
                
            case .memberInfo(let memberData):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelMemberCollectionViewCell.identifier, for: indexPath) as? ChannelMemberCollectionViewCell
                cell?.configure(image: memberData.profileImage, name: memberData.nickname)
                return cell
            }
        })
        //datasource supplymentviewprovider 헤더 추가해줄 자리
    }
    
    override func setUI() {
        super.setUI()
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
            
        }
    }
}
 
