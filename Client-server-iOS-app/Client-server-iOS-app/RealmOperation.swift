//
//  RealmOperation.swift
//  vk-api
//
//  Created by Илья Лебедев on 28.06.2021.
//

import Foundation
import RealmSwift

class RealmOperations {

    func saveFriendsToRealm(_ friendList: [Friend]) {
        do {
            let realm = try Realm()
            try realm.write{
                let oldFriendList = realm.objects(Friend.self) // список существующих записей
                realm.delete(oldFriendList) // удалить старые данные
                realm.add(friendList) // записать новые данные
            }
        } catch {
            print(error)
        }
    }
        
    func saveGroupsToRealm(_ grougList: [Group]) {
        do {
            let realm = try Realm()
            try realm.write{
                realm.add(grougList)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllFromRealm() {
        do {
            let realm = try Realm()
            try realm.write{
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
}
