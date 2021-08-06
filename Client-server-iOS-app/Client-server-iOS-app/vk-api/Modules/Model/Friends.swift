//
//  Friends.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import RealmSwift

//MARK: - FriendClass

class Friend: Object {
    @objc dynamic var userName: String = ""
    @objc dynamic var userAvatar: String = ""
    @objc dynamic var ownerID: String = ""
    
    init(userName: String, userAvatar: String, ownerID: String) {
        self.userName = userName
        self.userAvatar = userAvatar
        self.ownerID = ownerID
    }
    required override init(){
        super.init()
    }
    
}
