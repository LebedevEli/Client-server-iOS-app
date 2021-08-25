//
//  GetGroupOperation.swift
//  vk-api
//
//  Created by Илья Лебедев on 06.08.2021.
//

import Foundation
import RealmSwift

final class GetGroupOperation {
    
    lazy var operationQueue = OperationQueue()
    
    func getData() {
        let loadedJSONFromVK = LoadJSONData()
        let parsedDataFromJSON = ParseJSONData()
        let saveData = SaveDataToRealm()
        
        parsedDataFromJSON.addDependency(loadedJSONFromVK)
        saveData.addDependency(parsedDataFromJSON)
        
        let operations = [loadedJSONFromVK, parsedDataFromJSON, saveData]
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
}

class OperationAsync: Operation {
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        state = .finished
    }
    
    
}

final class LoadJSONData: OperationAsync {

    var jsonFromVK: Data?
    var errorFromVK: Error?

    override func main() {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)

        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.shared.userId)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
            URLQueryItem(name: "v", value: "5.131")
        ]

        let task = session.dataTask(with: urlConstructor.url!) { [weak self] (data, _, error) in

            guard let data = data else { return }

            self?.jsonFromVK = data
            self?.errorFromVK = error
            self?.state = .finished
        }
        task.resume()
    }
}

final class ParseJSONData: Operation {
    var dataFromJson: [Group]?
    var errorFromJSON: Error?
    
    override func main() {
        guard let operation = dependencies.first as? LoadJSONData,
              let data = operation.jsonFromVK
        else {return}
        
        do {
            let arrayGroups = try JSONDecoder().decode(GroupsResponse.self, from: data)
            var groupList: [Group] = []
            for i in 0...arrayGroups.response.items.count-1 {
                let name = ((arrayGroups.response.items[i].name))
                let logo = arrayGroups.response.items[i].logo
                let id = arrayGroups.response.items[i].id
                groupList.append(Group.init(groupName: name, groupLogo: logo, id: id))
            }
            
            dataFromJson = groupList
        } catch let error {
            errorFromJSON = error
            print(error.localizedDescription)
        }
    }
}

final class SaveDataToRealm: Operation {
    override func main() {
        guard let operation = dependencies.first as? ParseJSONData,
              let data = operation.dataFromJson
        else {return}
        DispatchQueue.main.async {
            RealmOperations().saveGroupsToRealm(data)
        }
        
    }
}
