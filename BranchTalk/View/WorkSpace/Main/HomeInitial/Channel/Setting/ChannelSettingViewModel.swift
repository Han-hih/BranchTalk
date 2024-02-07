//
//  ChannelSettingViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 2/4/24.
//

import Foundation
import RxSwift

class ChannelSettingViewModel: ViewModelType {
    
    private let userdefaults = UserDefaults.standard
    
    private let disposeBag = DisposeBag()
    
    var channelInfo = [ChannelInfo]()
    
    struct Input {
        let settingTrigger: Observable<Void>
    }
    
    struct Output {
        let settingTrigger: PublishSubject<ChannelInfo>
    }
    
    func transform(input: Input) -> Output {
        let settingTrigger = PublishSubject<ChannelInfo>()
        
        input.settingTrigger
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: ChannelInfo.self,
                    api: .getOneChannel(
                        name: self.userdefaults.string(forKey: "channelName") ?? "",
                        id: self.userdefaults.integer(forKey: "workSpaceID")
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("채널정보----------------------", response)
                    owner.channelInfo.append(response)
                    settingTrigger.onNext(response)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(settingTrigger: settingTrigger)
    }
}
