//
//  CoinShopViewConroller.swift
//  BranchTalk
//
//  Created by 황인호 on 3/1/24.
//

import UIKit
import WebKit
import RxSwift

import iamport_ios

final class CoinShopViewConroller: BaseViewController {
    
    private lazy var tableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
   private let completePayment = PublishSubject<Void>()
    
    var coin: Int? = nil
    
    private let viewModel = CoinShopViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    override func bind() {
        super.bind()
        let input = CoinShopViewModel.Input(completePayment: completePayment.asObservable())
        
        let output = viewModel.transform(input: input)
        output.completePayment.bind(with: self) { owner, result in
            owner.coin = (owner.coin ?? 0) + result.sesacCoin
            owner.tableView.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    override func setUI() {
        super.setUI()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    @objc func coinButtonTapped(_ sender: UIButton) {
        attachWebView()
        
        let payment = viewModel.createPayment(sender.titleLabel?.text ?? "")
        let userCode = APIKey.userCode
        Iamport.shared.paymentWebView(webViewMode: wkWebView, userCode: userCode, payment: payment) { [weak self] response in
            if response?.success == true {
                print("결제 성공!!!")
                self?.viewModel.impID = "\(response?.imp_uid ?? "")"
                self?.viewModel.merchantID = "muid_" + (response?.merchant_uid ?? "")
                self?.completePayment.onNext(())
                
            } else { print("결제 실패") }
            self?.removeWebView()
        }
        
    }
    
    //웹뷰
    private func attachWebView() {
        view.addSubview(wkWebView)
        wkWebView.frame = view.frame
        
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func removeWebView() {
        view.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
        wkWebView.uiDelegate = nil
        wkWebView.navigationDelegate = nil
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CoinShopViewConroller: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            let text = "🌱 현재 보유한 코인 \(coin ?? 0)개"
            cell.coinLabel.textColor = Colors.BrandGreen.CutsomColor
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: Colors.TextPrimary.CutsomColor, range: (text as NSString).range(of: "🌱 현재 보유한 코인"))
                        
            cell.coinLabel.attributedText = attributedString
            cell.priceButton.isHidden = true
            cell.label.isHidden = false
        }
        if indexPath.section == 1 {
            cell.label.isHidden = true
            cell.priceButton.addTarget(self, action: #selector(coinButtonTapped), for: .touchUpInside)
            cell.priceButton.isHidden = false
            if indexPath.row == 0 {
                cell.coinLabel.text = "🌱 10 Coin"
                cell.priceButton.setTitle("₩100", for: .normal)
            }
            if indexPath.row == 1 {
                cell.coinLabel.text = "🌱 50 Coin"
                cell.coinLabel.textColor = Colors.TextPrimary.CutsomColor
                cell.priceButton.setTitle("₩500", for: .normal)
            }
            if indexPath.row == 2 {
                cell.coinLabel.text = "🌱 100 Coin"
                cell.priceButton.setTitle("₩1000", for: .normal)
            }
        }
        
        return cell
    }
    
    
    
    
}
