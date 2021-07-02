//
//  APIServiceVar2.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import Foundation

//final class APIService {
//    let baseUrl = "https://api.vk.com/method"
//    let token = Session.shared.token
//    let clientId = Session.shared.userId
//    let version = "5.21"
//
//    func getFriendsQuicktype(completion: @escaping([User]) -> ()) {
//        let method = "/friends.get"
//
//        let parameters: Parameters = [
//            "user_id": clientId,
//            "order": "name",
//            "count": 100,
//            "fields": "photo_100",
//            "access_token": Session.shared.token,
//            "v": version]
//
//        let url = baseUrl + method
//
//        AF.request(url, method: .get, parameters: parameters).responseData{response in
//            guard let data = response.data else {return}
//            print(data.prettyJSON as Any)
//
//            let friendsResponse = try?
//                JSONDecoder().decode(Friends.self, from: data)
//
//            guard let friends = friendsResponse?.response.items
//            else {return}
//
//            DispatchQueue.main.async {
//                completion(friends)
//            }
//        }
//    }
//
////    func getFriendsManual(completion: ([User])->()) {
////
////            let method = "/friends.get"
////
////            let parameters: Parameters = [
////                "user_id": clientId,
////                "order": "name",
////                "count": 100,
////                "fields": "photo_100",
////                "access_token": Session.shared.token,
////                "v": version]
////
////            let url = baseUrl + method
////
////            AF.request(url, method: .get, parameters: parameters).responseData { response in
////
////
////                guard let data = response.data else { return }
////                print(data.prettyJSON as Any)
////
////                guard let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) else { return }
////
////                let object = json as! [String: Any]
////                let response = object["response"] as! [String: Any]
////                let items = response["items"] as! [Any]
////
////                for userJson in items {
////                    let userJson  = userJson as! [String: Any]
////                    let id = userJson["id"] as! Int
////                    let lastName = userJson["last_name"] as! String
////                    let firstName = userJson["first_name"] as! String
////
////                    print(id, firstName, lastName)
////                }
////            }
////
////            completion([])
////
////        }
//
//        //MARK: - Пока не совсем понимаю механику, но вроде что -то получается
//        func getGroupsUser() {
//
//            let method = "/groups.get"
//
//            let parameters: Parameters = [
//
//                "user_id": clientId,
//                "extended": "1",
//                "count": 100,
//                "access_token": Session.shared.token,
//                "v": version]
//
//            let url = baseUrl + method
//
//            AF.request(url, method: .get, parameters: parameters).responseData { response in
//
//                guard let data = response.data else {return}
//                print(data.prettyJSON as Any)
//
//            }
//
//        }
//}
