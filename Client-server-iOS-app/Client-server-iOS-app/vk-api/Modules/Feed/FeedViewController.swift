//
//  FeedViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit

class FeedViewController: UITableViewController {
    
    var news: [Feed] = []
    
    override func viewDidLoad() {
        
        tableView.refreshControl = myRefreshControl
        super.viewDidLoad()
        
        APIManager.shared.getPost(id: "post1", imageID: "3000") {res1 in
            self.news.append(res1!)
            APIManager.shared.getPost(id: "post2", imageID: "bitcoin") {res2 in
                self.news.append(res2!)
                APIManager.shared.getPost(id: "post3", imageID: "download") {res3 in
                    self.news.append(res3!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! FeedTableViewCell
        
//        // аватар
//        cell.avatarFeed.avatarImage.image = news[indexPath.row].avatar
//        // имя автора
//        cell.nameFeed.text = news[indexPath.row].name
//        // дата новости
//        cell.dateFeed.text = news[indexPath.row].date
//        cell.dateFeed.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
//        cell.dateFeed.textColor = UIColor.gray.withAlphaComponent(0.5)
//        //текст новости
//        cell.textFeed.text = news[indexPath.row].text
//        cell.textFeed.numberOfLines = 0
//        //картинка к новости
//        cell.imageFeed.image = news[indexPath.row].textImage
//        cell.imageFeed.contentMode = .scaleAspectFill
        cell.nameFeed.text = news[indexPath.row].name
        cell.dateFeed.text = news[indexPath.row].date
        cell.textFeed.text = news[indexPath.row].text
        cell.imageFeed.image = news[indexPath.row].textImage
        cell.avatarFeed.avatarImage.image = news[indexPath.row].avatar
        return cell
    }
    
    //MARK: - рефреш контрол (обновление страницы)
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }

}
