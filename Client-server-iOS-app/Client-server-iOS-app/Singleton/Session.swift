//
//  Session.swift
//  Client-server-iOS-app
//
//  Created by Илья Лебедев on 17.06.2021.
//

import Foundation
import UIKit

class Session{
    private init() {}
    static let instance = Session()
    
    var token: String = "" //Хранение токена ВК
    var userID: Int = 0 //хранение идентификатора пользователя VK
}
