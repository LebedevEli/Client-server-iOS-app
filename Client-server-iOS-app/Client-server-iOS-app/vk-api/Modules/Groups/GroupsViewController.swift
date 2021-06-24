//
//  GroupsViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit

class GroupsViewController: UITableViewController {
    
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.getGroupsUser {groups in
            print(groups)
        }
    }
}
