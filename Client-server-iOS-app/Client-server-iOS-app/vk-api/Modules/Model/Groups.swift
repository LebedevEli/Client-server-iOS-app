//
//  Groups.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import RealmSwift

class Group: Object {
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupLogo: String  = ""
    
    init(groupName: String, groupLogo: String) {
        self.groupName = groupName
        self.groupLogo = groupLogo
    }
    
    // этот инит обязателен для Object
    required override init() {
        super.init()
    }
    
    // в классе типа Object не нужно (можно сравнить по дескрипшину)
    // для проведения сравнения (.contains), только по имени
//    static func ==(lhs: Group, rhs: Group) -> Bool {
//        return lhs.groupName == rhs.groupName //&& lhs.groupLogo == rhs.groupLogo
//    }
}
