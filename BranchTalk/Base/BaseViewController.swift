//
//  BaseViewController.swift
//  BranchTalk
//
//  Created by 황인호 on 1/4/24.
//

import UIKit
import RxSwift

import SnapKit

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.view.backgroundColor = Colors.BackgroundSecondary.CutsomColor
        setUI()
        setNav()
        bind()
    }
    
    func setUI() {
        
    }
    
    func setNav() {
        
    }
    
    func bind() {
        
    }
    
}
