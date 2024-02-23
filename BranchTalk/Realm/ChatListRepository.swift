//
//  ChatListRepository.swift
//  BranchTalk
//
//  Created by 황인호 on 2/19/24.
//

import Foundation
import RealmSwift

protocol ChatListRepositoryType: AnyObject {
    func createItem(_ item: ChatDetailTable)
}

class ChatListRepository {
    
    static let shared = ChatListRepository()
    
    
    private let realm = try! Realm()
    private init() { }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
            
        } catch {
            print(error)
        }
    }
    
    func createItem(_ item: ChatDetailTable) {
        print(realm.configuration.fileURL!)
        do {
            try realm .write {
                realm.add(item, update: .all)
                print(realm.configuration.fileURL)
            }
        } catch {
            print(error)
        }
    }
}

