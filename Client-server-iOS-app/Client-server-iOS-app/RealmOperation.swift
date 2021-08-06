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
                let oldFriendList = realm.objects(Friend.self)
                realm.delete(oldFriendList)
                realm.add(friendList)
            }
        } catch {
            print(error)
        }
    }
    
    func savePhotosToRealm(_ photoList: [Photo], _ ownerID: String) {
        do {
            let realm = try Realm()
            try realm.write {
                let oldPhotoList = realm.objects(Photo.self).filter("ownerID == %@", ownerID)
                realm.delete(oldPhotoList)
                realm.add(photoList)
            }
        } catch {
            print(error)
        }
    }
        
    func saveGroupsToRealm(_ groupList: [Group]) {
        do {
            let realm = try Realm()
            try realm.write{
                let oldGroupList = realm.objects(Group.self)
                realm.delete(oldGroupList)
                realm.add(groupList)
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
