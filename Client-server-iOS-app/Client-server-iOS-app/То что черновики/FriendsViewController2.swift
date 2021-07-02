//
//  FriendsViewController2.swift
//  vk-api
//
//  Created by Илья Лебедев on 29.06.2021.
//

import Foundation

//class FriendsTableViewController: UITableViewController {
//
//    //outlets
//    @IBOutlet var friendsTableView: UITableView!
//
//    let apiService = APIService()
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////      apiService.getFriendsQuicktype { users in
////
////        print(users)
////      }
////
////    }
//
//    var friend: Friend!
//
//    var friends = [
//        Friend(name: "Oleg Olegov", avatar: #imageLiteral(resourceName: "20"), photos: [#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "20")]),
//        Friend(name: "Ilya Ilin", avatar: #imageLiteral(resourceName: "14"), photos: [#imageLiteral(resourceName: "12"),#imageLiteral(resourceName: "13"),#imageLiteral(resourceName: "14")]),
//        Friend(name: "Andrey Andreev", avatar: #imageLiteral(resourceName: "9"), photos: [#imageLiteral(resourceName: "11"),#imageLiteral(resourceName: "11"),#imageLiteral(resourceName: "17")]),
//        Friend(name: "Alex Alexeev", avatar: #imageLiteral(resourceName: "16"), photos: [#imageLiteral(resourceName: "19"),#imageLiteral(resourceName: "18"),#imageLiteral(resourceName: "17")]),
//        Friend(name: "Daniil Daniilov", avatar: #imageLiteral(resourceName: "22"), photos: [#imageLiteral(resourceName: "23"),#imageLiteral(resourceName: "24"),#imageLiteral(resourceName: "21")]),
//    ]
//
//    private var filteredFriends = [Friend]()
//
//    private var searchBarIsEmpty: Bool {
//            guard let text = searchController.searchBar.text else {return false}
//            return text.isEmpty
//        }
//
//    private var isFiltering: Bool {
//            return searchController.isActive && !searchBarIsEmpty
//        }
//
//    let searchController = UISearchController(searchResultsController: nil)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        friendsTableView.dataSource = self
//        friendsTableView.delegate = self
//        friendsTableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
//
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search"
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//
//        apiService.getFriendsQuicktype { users in
//
//          print(users)
//        }
//    }
//
//    func arrayLetter() -> [String] {
//            var resultArray = [String]()
//
//            for item in friends {
//                let nameLetter = String(item.name!.prefix(1))
//                if !resultArray.contains(nameLetter) {
//                    resultArray.append(nameLetter)
//                }
//            }
//           return resultArray
//        }
//
//
//        func arrayByLetter(letter: String) -> [Friend] {
//            var resultArray = [Friend]()
//
//            for item in friends {
//                let nameLetter = String(item.name!.prefix(1))
//                if nameLetter == letter {
//                    resultArray.append(item)
//                }
//            }
//           return resultArray
//        }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            return arrayLetter()[section].uppercased()
//        }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if isFiltering {
//            return 1
//        }
//        return arrayLetter().count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering {
//            return filteredFriends.count
//        }
//        return arrayByLetter(letter: arrayLetter()[section]).count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as? FriendsTableViewCell else {return UITableViewCell()}
//
//        let arrayByLetterItems = arrayByLetter(letter: arrayLetter()[indexPath.section])
//
//        if isFiltering {
//            friend = filteredFriends[indexPath.row]
//        } else {
//            friend = arrayByLetterItems[indexPath.row]
//        }
//
//        friendsTableView.rowHeight = 50
//
//        cell.configureWithFriend(friend: friend)
//
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let arrayByLetterItems = arrayByLetter(letter: arrayLetter()[indexPath.section])
//        if isFiltering {
//            friend = filteredFriends[indexPath.row]
//        } else {
//            friend = arrayByLetterItems[indexPath.row]
//        }
//        performSegue(withIdentifier: "showPhotos", sender: nil)
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            friends.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showPhotos" {
//            let collectionVC = segue.destination as! PhotoCollectionViewController
//            collectionVC.friend = friend
//        }
//    }
//
//}
//
//extension FriendsTableViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//
//            filterContentForSearchText(searchController.searchBar.text!)
//        }
//
//    private func filterContentForSearchText(_ searchText: String) {
//
//            filteredFriends = friends.filter({ (friend: Friend) -> Bool in
//                return friend.name!.lowercased().contains(searchText.lowercased())
//            })
//            friendsTableView.reloadData()
//        }
//}
