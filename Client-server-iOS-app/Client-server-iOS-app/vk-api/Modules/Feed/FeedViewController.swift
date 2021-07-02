//
//  FeedViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit

class FeedViewController: UITableViewController {
    
    var news = [
    Feed(name: "Elon Musk", avatar: #imageLiteral(resourceName: "28"), date: "02.07.2021", textNews: "Bitcoin's price fell Friday morning after Elon Musk posted a tweet suggesting he's fallen out of love with the world's top cryptocurrency. The billionaire Tesla CEO tweeted a meme about a couple breaking up over the male partner quoting Linkin Park lyrics, adding the hashtag #Bitcoin and a broken heart emoji.", textImage: #imageLiteral(resourceName: "21")),
    Feed(name: "Barack Obama", avatar: #imageLiteral(resourceName: "30"), date: "01.06.2021", textNews: "Trump broke ‘core tenet’ of democracy with ‘bunch of hooey’ over election", textImage: #imageLiteral(resourceName: "29"))
    ]
    
    override func viewDidLoad() {
        
        tableView.refreshControl = myRefreshControl
        super.viewDidLoad()
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
        
        // аватар
        cell.avatarFeed.avatarImage.image = news[indexPath.row].avatar
        // имя автора
        cell.nameFeed.text = news[indexPath.row].name
        // дата новости
        cell.dateFeed.text = news[indexPath.row].date
        cell.dateFeed.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        cell.dateFeed.textColor = UIColor.gray.withAlphaComponent(0.5)
        //текст новости
        cell.textFeed.text = news[indexPath.row].textNews
        cell.textFeed.numberOfLines = 0
        //картинка к новости
        cell.imageFeed.image = news[indexPath.row].textImage
        cell.imageFeed.contentMode = .scaleAspectFill

        return cell
    }
    
    //MARK: - рефреш контрол (обновление страницы)
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }

}
