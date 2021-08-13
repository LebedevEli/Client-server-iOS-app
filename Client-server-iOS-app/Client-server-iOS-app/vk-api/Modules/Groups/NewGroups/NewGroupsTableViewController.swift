//
//  NewGroupsTableViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 01.07.2021.
//

import UIKit

class NewGroupsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    var searchController:UISearchController!
    var GroupsList: [Group] = []
    
    lazy var imageCache = ImageCache(container: self.tableView)
    
    // MARK: - Functions
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Введите запрос для поиска"
        tableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.isActive = true
        DispatchQueue.main.async {
          self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchGroupVK(searchText: String) {
        SearchGroup().loadData(searchText: searchText) { [weak self] (complition) in
            DispatchQueue.main.async {
                //print(complition)
                self?.GroupsList = complition
                self?.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchGroupVK(searchText: searchText)
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroup", for: indexPath)  as! NewGroupTableViewCell

        cell.nameNewGroupLabel.text = GroupsList[indexPath.row].groupName
        
//        if let imgUrl = URL(string: GroupsList[indexPath.row].groupLogo) {
//            cell.avatarNewGroup.avatarImage.load(url: imgUrl)
//        }
        
        let imgUrl = GroupsList[indexPath.row].groupLogo
        cell.avatarNewGroup.avatarImage.image = imageCache.getPhoto(at: indexPath, url: imgUrl)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
