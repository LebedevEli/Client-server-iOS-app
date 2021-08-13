//
//  SearchGroup.swift
//  vk-api
//
//  Created by Илья Лебедев on 28.06.2021.
//

import Foundation


class SearchGroup {
    
    func loadData(searchText:String, complition: @escaping ([Group]) -> Void ) {
        
        let configuration = URLSessionConfiguration.default
        
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
            
            guard let data = data else { return }

            do {
                let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
                var searchGroup: [Group] = []
                for i in 0...arrayGroups.response.items.count-1 {
                    let name = ((arrayGroups.response.items[i].name))
                    let logo = arrayGroups.response.items[i].logo
                    let id = arrayGroups.response.items[i].id
                    searchGroup.append(Group.init(groupName: name, groupLogo: logo, id: id))
                }
                complition(searchGroup)
            } catch let error {
                print(error)
                complition([])
            }
        }
        task.resume()
        
    }
    
}
