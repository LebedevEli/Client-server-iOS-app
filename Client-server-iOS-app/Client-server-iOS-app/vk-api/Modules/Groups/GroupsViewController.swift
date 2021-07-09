//
//  GroupsViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import Kingfisher

class GroupsViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myRefreshControl

        //получение данного JSON
        GetGroupsList().loadData()
    }
    
    var myGroups: [Group] = []
    
    //RefreshControl
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        cell.nameGroupLabel.text = myGroups[indexPath.row].groupName
        
        if let imgURL = URL(string: myGroups[indexPath.row].groupLogo) {
            let avatar = ImageResource(downloadURL: imgURL) //работает с KingFisher!!
            cell.avatarGroup.avatarImage.kf.indicatorType = .activity //работает с KingFisher!!
            cell.avatarGroup.avatarImage.kf.setImage(with: avatar) //работает с KingFisher!!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade) // не обязательно удалять строку, если используется reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //кратковременное подсвечивание при нажатии на ячейку
    }
    
    
    //MARK: - рефреш контрол (обновление страницы)
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    } //Работает пока коряво.
    
    //MARK: - добавление новой группы из другого контроллера
    
    @IBAction func addGroup(segue:UIStoryboardSegue) {
        // проверка по идентификатору верный ли переход с ячейки
        if segue.identifier == "AddGroup" {
            // ссылка объект на контроллер с которого переход
            guard let newGroupFromController = segue.source as? NewGroupsTableViewController else {return}
            // проверка индекса ячейки
            if let indexPath = newGroupFromController.tableView.indexPathForSelectedRow {
                //добавить новой группы в мои группы из общего списка групп
                let newGroup = newGroupFromController.GroupList[indexPath.row]
                // проверка что группа уже в списке (нужен Equatable)
                guard !myGroups.description.contains(newGroup.groupName) else {return}
                myGroups.append(newGroup)
                
                RealmOperations().saveGroupsToRealm(myGroups)
                
                tableView.reloadData()
            }
        }
    }
    
}
