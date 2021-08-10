//
//  APIService.swift
//  vk-api
//
//  Created by Илья Лебедев on 22.06.2021.
//
//import Alamofire
//import Foundation

//final class APIService {
//    let baseUrl = "https://api.vk.com/method"
//    let token = Session.shared.token
//    let clientId = Session.shared.userId
//    let ownerId = Session.shared.userId
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
//        //MARK: - Пока не совсем понимаю механику, но вроде что -то получается
//    func getGroupsUser(completion: @escaping([Groups]) -> Void ) {
//
//            let method = "/groups.get"
//
//            let parameters: Parameters = [
//
//                "user_id": clientId,
//                "extended": 1,
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
//                do {
//                    let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
//                    var fullGroupList: [Groups] = []
//                    for i in 0...arrayGroups.response.items.count-1 {
//                        let name = ((arrayGroups.response.items[i].name))
//                        let avatar = arrayGroups.response.items[i].photo_50
//                        fullGroupList.append(Groups.init(groupName: name, groupLogo: avatar))
//                    }
//                    completion(fullGroupList)
//                } catch let error {
//                    print(error)
//                    completion([])
//                }
//
//            }
//
//        }
//    
//    func getPhotosFriend (completion: @escaping([String]) -> ()) {
//        let method = "/photos.getAll"
//        
//        let parameters: Parameters = [
//        
//            "user_id": ownerId,
//            "extended": 1,
//            "count": 50,
//            "access_token": Session.shared.token,
//            "v": version
//        ]
//        
//        let url = baseUrl + method
//        
//        AF.request(url, method: .get, parameters: parameters).responseData { response in
//            guard let data = response.data else {return}
//            print(data.prettyJSON as Any)
//            
//            do {
//                let arrayPhotosFriend = try JSONDecoder().decode(PhotosResponse.self, from: data)
//                var photosFriend: [String] = []
//                
//                for i in 0...arrayPhotosFriend.response.items.count-1 {
//                    if let urlPhoto = arrayPhotosFriend.response.items[i].sizes.last?.url {
//                        photosFriend.append(urlPhoto)
//                    }
//                }
//                completion(photosFriend)
//            } catch let error {
//                print(error)
//                completion([])
//            }
//    }
//}
//}
