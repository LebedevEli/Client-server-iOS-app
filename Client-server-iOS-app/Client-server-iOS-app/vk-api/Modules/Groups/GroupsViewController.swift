//
//  GroupsViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import Kingfisher
import RealmSwift
import FirebaseDatabase

class GroupsViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotificationRealm()
        
        tableView.refreshControl = myRefreshControl

//        GetGroupsList().loadData() // обычный способ
        GetGroupOperation().getData() //Способ с Operations
    }
    
    var realm: Realm = {
        let configrealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configrealm)
        return realm
    }()
    
    lazy var groupsFromRealm: Results<Group> = {
        return realm.objects(Group.self)
    }()
    
    var notificationToken: NotificationToken?
    
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
            
           
            do {
                try realm.write{
                    realm.delete(groupsFromRealm.filter("groupName == %@", myGroups[indexPath.row].groupName))
                }
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - рефреш контрол (обновление страницы)
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    //MARK: - Func
    
    private func subscribeToNotificationRealm() {
        notificationToken = groupsFromRealm.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                self?.loadGroupsFromRealm()
            
            case .update:
                self?.loadGroupsFromRealm()

            case let .error(error):
                print(error)
            }
        }
    }
    
    func loadGroupsFromRealm() {
            myGroups = Array(groupsFromRealm)
            guard groupsFromRealm.count != 0 else { return }
            tableView.reloadData()
    }
    
    //MARK: - добавление новой группы из другого контроллера
    
    @IBAction func addGroup(segue:UIStoryboardSegue) {
        if segue.identifier == "AddGroup" {
            guard let newGroupFromController = segue.source as? NewGroupsTableViewController else {return}
            if let indexPath = newGroupFromController.tableView.indexPathForSelectedRow {
                let newGroup = newGroupFromController.GroupsList[indexPath.row]
                guard !myGroups.description.contains(newGroup.groupName) else {return}
                myGroups.append(newGroup)
                
                RealmOperations().saveGroupsToRealm(myGroups)
                
                tableView.reloadData()
            }
        }
    }
    
    //MARK: - Firebase
    
    private func writeNewGroupToFirebase(_ newGroup: Group){
        let database = Database.database()
        let ref: DatabaseReference = database.reference(withPath: "All logged users").child(String(Session.shared.userId))
        
        ref.observe(.value) { snapshot in
            
            let groupsIDs = snapshot.children.compactMap { $0 as? DataSnapshot }
                .compactMap { $0.key }
            guard groupsIDs.contains(String(newGroup.id)) == false else { return }
    
            ref.child(String(newGroup.id)).setValue(newGroup.groupName)
            
            print("Для пользователя с ID: \(String(Session.shared.userId)) в Firebase записана группа:\n\(newGroup.groupName)")
            
            let groups = snapshot.children.compactMap { $0 as? DataSnapshot }
            .compactMap { $0.value }
            
            print("\nРанее добавленные в Firebase группы пользователя с ID \(String(Session.shared.userId)):\n\(groups)")
            ref.removeAllObservers() 
        }
    }
    
}
