//
//  Groups.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import Foundation

struct Groups: Equatable {
    let groupName: String
    //let groupLogo: UIImage?
    let groupLogo: String
    
    // для проведения сравнения (.contains), только по имени
    static func ==(lhs: Groups, rhs: Groups) -> Bool {
        return lhs.groupName == rhs.groupName //&& lhs.groupLogo == rhs.groupLogo
    }
}

struct GroupsResponse: Codable {
    var response: Response
    
    struct Response: Codable {
        var count: Int
        var items: [Items]
        
        struct Items: Codable {
            var id: Int
            var name: String
            var screen_name: String
            var photo_50: String
        }
    }
}
