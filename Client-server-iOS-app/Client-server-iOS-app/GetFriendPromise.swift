//
//  GetFriendPromise.swift
//  vk-api
//
//  Created by Илья Лебедев on 10.08.2021.
//

import Foundation
import PromiseKit

class GetFriendsListPromise {
    
    func getData() {
        firstly {
            loadJsonData()
        }.then { data in
            self.parseJSONData(data)
        }.done { friendList in
            self.saveDataToRealm(friendList)
        }.catch { error in
            print(error)
        }
    }
    
    func loadJsonData() -> Promise<Data> {
        return Promise<Data> { (resolver) in
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            var urlConstructor = URLComponents()
            urlConstructor.scheme = "https"
            urlConstructor.host = "api.vk.com"
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
                URLQueryItem(name: "fields", value: "photo_50"),
                URLQueryItem(name: "access_token", value: Session.shared.token),
                URLQueryItem(name: "v", value: "5.131")
            ]
            
            session.dataTask(with: urlConstructor.url!) {(data, _, error) in
                if let error = error {
                    return resolver.reject(error)
                } else {
                    return resolver.fulfill(data ?? Data())
                }
            }.resume()
        }
    }
    
    func parseJSONData(_ data: Data) -> Promise<[Friend]> {
        return Promise<[Friend]> { (resolver) in
            do {
                let arrayFriends = try JSONDecoder().decode(FriendsResponse.self, from: data)
                var friendList: [Friend] = []
                for i in 0 ... arrayFriends.response.items.count - 1 {
                    if arrayFriends.response.items[i].deactivated == nil {
                        let name = ((arrayFriends.response.items[i].firstName) + " " + (arrayFriends.response.items[i].lastName))
                        let avatar = arrayFriends.response.items[i].avatar
                        let id = String(arrayFriends.response.items[i].id)
                        friendList.append(Friend.init(userName: name, userAvatar: avatar, ownerID: id))
                    }
                }
                resolver.fulfill(friendList)
            } catch let error {
                resolver.reject(error)
            }
        }
    }
    
    func saveDataToRealm(_ friendList: [Friend]) {
        RealmOperations().saveFriendsToRealm(friendList)
    }
    
}
