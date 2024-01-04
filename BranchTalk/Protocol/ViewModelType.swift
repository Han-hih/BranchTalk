//
//  ViewModelType.swift
//  BranchTalk
//
//  Created by 황인호 on 1/5/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
