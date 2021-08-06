//
//  FriendsViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 22.06.2021.
//


import UIKit
import Kingfisher
import RealmSwift

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var friendsTableView: UITableView!
    

    
    override func viewDidLoad() {
        
        tableView.refreshControl = myRefreshControl
        super.viewDidLoad()
        
        subNotificationRealm() // подписываемся на уведомления realm
        
//        loadFriendsFromRealm() // загрузка данных из реалма (кэш) для первоначального отображения
        GetFriendsList().loadData()
        
        searchBar.delegate = self
    }
    
    var realm: Realm = {
        let configurateRealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configurateRealm)
        return realm
    }()
    
    lazy var friendsFromRealm: Results<Friend> = {
        return realm.objects(Friend.self)
    }()
    
    var notificationToken: NotificationToken?
    
    var friendsList: [Friend] = []
    var namesListFixed: [String] = []
    var namesListModifed: [String] = []
    var letersOfNames: [String] = []
    
    
    //RefreshControl
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Table view
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
      return letersOfNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)

        let leter: UILabel = UILabel(frame: CGRect(x: 30, y: 5, width: 20, height: 20))
        leter.textColor = UIColor.black.withAlphaComponent(0.5)
        leter.text = letersOfNames[section]
        leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        header.addSubview(leter)

        return header
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letersOfNames
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfRows = 0
        for name in namesListModifed {
            if letersOfNames[section].contains(name.first!) {
                countOfRows += 1
            }
        }
        return countOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
        
        cell.nameFriend.text = self.getNameFriendForCell(indexPath)
        
        guard let imgUrl = self.getAvatarFriendForCell(indexPath) else { return cell }
            let avatar = ImageResource(downloadURL: imgUrl)
        cell.avatarView.avatarImage.kf.indicatorType = .activity
        cell.avatarView.avatarImage.kf.setImage(with: avatar)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - functions
    
    private func subNotificationRealm() {
        notificationToken = friendsFromRealm.observe({ [weak self] changes in
            switch changes {
            case .initial:
                self?.loadFriendsFromRealm()
            case .update:
                self?.loadFriendsFromRealm()
            case let .error(error):
                print(error)
            }
        })
    }
    
    func loadFriendsFromRealm() {
        
        friendsList = Array(friendsFromRealm)
        guard friendsList.count != 0 else {return}
        makeNamesList()
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    
    func makeNamesList() {
        namesListFixed.removeAll()
        for item in 0...(friendsList.count - 1){
            namesListFixed.append(friendsList[item].userName)
        }
        namesListModifed = namesListFixed
    }
    
    func sortCharacterOfNamesAlphabet() {
        var letersSet = Set<Character>()
        letersOfNames = []
        for name in namesListModifed {
            letersSet.insert(name[name.startIndex])
        }
        for leter in letersSet.sorted() {
            letersOfNames.append(String(leter))
        }
    }
    
    func getNameFriendForCell(_ indexPath: IndexPath) -> String {
        var namesRows = [String]()
        for name in namesListModifed.sorted() {
            if letersOfNames[indexPath.section].contains(name.first!) {
                namesRows.append(name)
            }
        }
        return namesRows[indexPath.row]
    }
    
    func getAvatarFriendForCell(_ indexPath: IndexPath) -> URL? {
        for friend in friendsList {
            let namesRows = getNameFriendForCell(indexPath)
            if friend.userName.contains(namesRows) {
                return URL(string: friend.userAvatar)
            }
        }
        return nil
    }
    
    func getIDFriend(_ indexPath: IndexPath) -> String {
        var ownerIDs = ""
        for friend in friendsList {
            let namesRows = getNameFriendForCell(indexPath)
            if friend.userName.contains(namesRows) {
                ownerIDs = friend.ownerID
            }
        }
        return ownerIDs
    }
    //MARK: - рефреш контрол (обновление страницы)
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    
    // MARK: - searchBar
    // поиск по именам
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        namesListModifed = searchText.isEmpty ? namesListFixed : namesListFixed.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
    }
    

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = nil
        makeNamesList()
        sortCharacterOfNamesAlphabet()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListUsersPhoto"{
            guard let friend = segue.destination as? PhotoCollectionViewController else { return }

            if let indexPath = tableView.indexPathForSelectedRow {
                friend.title = getNameFriendForCell(indexPath)
                friend.ownerID = getIDFriend(indexPath)
            }
        }
    }
    
}
    
    
    
    
    
    
    
    
    
