//
//  PhotoForGet.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import Foundation

struct PhotosResponse: Codable {
    var response: Response
    
    struct Response: Codable {
        var count: Int
        var items: [Items]
        
        struct Items: Codable {
            var album_id: Int
            var date: Int
            var id: Int
            var owner_id: Int
            var has_tags: Bool
            var sizes: [Sizes]
            var text: String
            
            struct Sizes: Codable {
                var height: Int
                var url: String
                var type: String
                var width: Int
            }
        }
    }
}
