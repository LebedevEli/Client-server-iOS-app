//
//  NewGroupsTableViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 01.07.2021.
//

import UIKit

class NewGroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
    }
    
    var GroupList: [Group] = []
    var searchController: UISearchController!
    
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Введите запрос для поиска"
        tableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false// не скрывать таблицу под поиском (размытие), иначе не будет работать сегвей из поиска
        
        //автоматическое открытие клавиатуры для поиска
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchGroupVK(searchText: String) {
        // получение данных JSON
        SearchGroup().loadData(searchText: searchText) { [weak self] (complition) in
            DispatchQueue.main.async {
                self?.GroupList = complition
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return GroupList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGroup", for: indexPath)  as! NewGroupTableViewCell

        cell.nameNewGroupLabel.text = GroupList[indexPath.row].groupName
        
        if let imgUrl = URL(string: GroupList[indexPath.row].groupLogo) {
            cell.avatarNewGroup.avatarImage.load(url: imgUrl) // работает через extension UIImageView+load URL
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // кратковременное подсвечивание при нажатии на ячейку
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewGroupsTableViewController: UISearchResultsUpdating{
    
}
