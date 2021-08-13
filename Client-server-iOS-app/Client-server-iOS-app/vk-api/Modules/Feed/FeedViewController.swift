//
//  FeedViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit

class FeedViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GetNewsList().loadData { complition in
//            DispatchQueue.main.async {
//                self.postNewsList = complition
//                self.tableView.reloadData()
//            }
//        }
        getNewsListSwiftyJSON.get { [weak self] (complition) in
            self?.postNewsList = complition
            self?.tableView.reloadData()
        }
        
    }
    
    lazy var getNewsListSwiftyJSON = GetNewsListSwiftyJSON()
    lazy var imageCache = ImageCache(container: self.tableView)
  
    var postNewsList: [PostNews] = []

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postNewsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String
        
        if postNewsList[indexPath.row].textNews.isEmpty {
            identifier = "PhotoCell"
        } else {
            identifier = "PostCell"
        }
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FeedTableViewCell
        
//        guard let avatarUrl = URL(string: postNewsList[indexPath.row].avatar ) else { return cell }
//        cell.avatarUserFeed.avatarImage.load(url: avatarUrl)
        
        cell.avatarUserFeed.avatarImage.image = imageCache.getPhoto(at: indexPath, url: postNewsList[indexPath.row].avatar)
        
        cell.nameUserFeed.text = postNewsList[indexPath.row].name
        
        cell.dateNews.text = postNewsList[indexPath.row].date
        cell.dateNews.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        cell.dateNews.textColor = UIColor.gray.withAlphaComponent(0.5)
        
        if identifier == "PostCell" {
            cell.textNewsPost.text = postNewsList[indexPath.row].textNews
        }
        
        guard let imgUrl = URL(string: postNewsList[indexPath.row].imageNews ) else { return cell }
        cell.imgNews.load(url: imgUrl)
        cell.imgNews.contentMode = .scaleAspectFill
        
        cell.likesCount.countLikes = postNewsList[indexPath.row].likes
        cell.likesCount.labelLikes.text = String(postNewsList[indexPath.row].likes)
        
        cell.commentsCount.setTitle(String(postNewsList[indexPath.row].comments), for: .normal)
        
        cell.repostsCount.setTitle(String(postNewsList[indexPath.row].reposts), for: .normal)
        
        cell.viewsCount.setTitle(String(postNewsList[indexPath.row].views), for: .normal)
        

        return cell
    }

}
