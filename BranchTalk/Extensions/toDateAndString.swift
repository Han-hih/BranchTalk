//
//  toDateAndString.swift
//  BranchTalk
//
//  Created by 황인호 on 1/24/24.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: self)
    }
    
    func toFormattedString() -> String? {
        guard let date = self.toDate() else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. MM. dd"
        return dateFormatter.string(from: date)
    }
    
    func toChannelCreatedTime() -> String? {
        guard let date = self.toDate() else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    func backChattingString() -> String? {
        guard let date = self.toDate() else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd\nhh:mm a"
        return dateFormatter.string(from: date)
        
    }
}
