//
//  CoinShopViewModel.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import Foundation
import RxSwift
import iamport_ios

class CoinShopViewModel: ViewModelType {
    
    var impID = ""
    var merchantID = ""
    
    var haveCoin = 0
    var resultCoin = 0
    
    private let disposeBag = DisposeBag()
    struct Input {
        let completePayment: Observable<Void>
    }
    
    struct Output {
        let completePayment: PublishSubject<billingResult>
    }
    
    func transform(input: Input) -> Output {
        let completePayment = PublishSubject<billingResult>()
        
        input.completePayment
            .flatMapLatest { _ in
                NetworkManager.shared.requestSingle(
                    type: billingResult.self,
                    api: .coinValidation(imp: self.impID, mer: self.merchantID)
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print(response)
                    owner.resultCoin = owner.haveCoin + response.sesacCoin
                    completePayment.onNext(response)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
                
        
        return Output(completePayment: completePayment)
    }
    
    func createPayment(_ value: String) -> IamportPayment {
        let amount = value.replacingOccurrences(of: "₩", with: "")
        let coin = (Int(amount) ?? 0) / 10
        
        let payment = IamportPayment(
            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
            merchant_uid: "ios_\(APIKey.apiKey)_\(Int(Date().timeIntervalSince1970))",
            amount: amount).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = "\(coin) Coin"
                $0.buyer_name = "황인호"
                $0.app_scheme = "sesac"
            }

        return payment
    }
    
}
