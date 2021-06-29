//
//  Session.swift
//  vk-api
//
//  Created by Илья Лебедев on 22.06.2021.
//

import Foundation
import SwiftKeychainWrapper

final class Session {
    static let shared = Session()
    
    private init() {}
    
    var token: String { //Хранение токена ВК
        get {KeychainWrapper.standard.string(forKey: "tokenVK") ?? ""}
        set {KeychainWrapper.standard.set(newValue, forKey: "tokenVK")}
    }
    
    var userId: Int { //Хранение идентификатора пользователя ВК
        get {KeychainWrapper.standard.integer(forKey: "userId") ?? 0}
        set {KeychainWrapper.standard.set(newValue, forKey: "userId")}
    }
    
    var expiredDate: Date {
        get {
            UserDefaults.standard.register(defaults: ["expiresIn" : Date()])
            return UserDefaults.standard.object(forKey: "expiresIn") as! Date
        }
        set {UserDefaults.standard.set(newValue, forKey: "expiresIn")}
    }
    
}
