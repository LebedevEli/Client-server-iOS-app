//
//  Friends.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import Foundation

 // MARK: - Friends
 struct Friends: Codable {
     let response: Response
 }

 // MARK: - Response
 struct Response: Codable {
     let count: Int
     let items: [User]
 }

 // MARK: - Item
 struct User: Codable {
     let id: Int
     let lastName, trackCode, firstName: String?
     let photo100: String?
     let deactivated: Deactivated?

     enum CodingKeys: String, CodingKey {
         case id
         case lastName = "last_name"
         case trackCode = "track_code"
         case firstName = "first_name"
         case photo100 = "photo_100"
         case deactivated
     }
 }

 enum Deactivated: String, Codable {
     case banned = "banned"
     case deleted = "deleted"
 }
