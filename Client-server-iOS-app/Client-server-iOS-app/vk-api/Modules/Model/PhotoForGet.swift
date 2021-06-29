//
//  PhotoForGet.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import RealmSwift

class Photo: Object {
    @objc dynamic var photo: String = ""
    
    init(photo: String) {
        self.photo = photo
    }
    
    // этот инит обязателен для Object
    required override init() {
        super.init()
    }
}
