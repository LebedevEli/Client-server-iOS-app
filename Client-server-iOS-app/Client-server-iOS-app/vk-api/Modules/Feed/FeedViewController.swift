//
//  FeedViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit

class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        tableView.prefetchDataSource = self
        loadNews()
        
//        GetNewsList().loadData { complition in
//            DispatchQueue.main.async {
//                self.postNewsList = complition
//                self.tableView.reloadData()
//            }
//        }
//
//        getNewsListSwiftyJSON.get { [weak self] (complition) in
//            self?.postNewsList = complition
//            self?.tableView.reloadData()
//        }
        
    }
    
    lazy var getNewsListSwiftyJSON = GetNewsListSwiftyJSON()
    lazy var imageCache = ImageCache(container: self.tableView)
    var postNewsList: [PostNews] = []
    
    var nextNewsID = ""
    var isLoadingNews = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return df
    }()
    //MARK: - News loading
    
    func loadNews() {
        getNewsListSwiftyJSON.get { [weak self] (news, nextFromID) in
            guard let self = self else {return}
            self.postNewsList = news
            self.nextNewsID = nextFromID
            self.tableView.reloadData()
        }
    }
    
    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Новости загружаются")
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(refreshNewsList), for: .valueChanged)
    }
    
    @objc private func refreshNewsList() {
        if let dateFrom = postNewsList.first?.date {
            let timestamp = dateFormatter.date(from: dateFrom)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            
            getNewsListSwiftyJSON.get(newsFrom: timestamp + 1) { [weak self] (latesNews, _)  in
                guard let self = self else {return}
                guard latesNews.count > 0 else {return}
                self.postNewsList = latesNews + self.postNewsList
                
                let indexPaths = (0..<latesNews.count)
                    .map{ IndexPath(row: $0, section: 0)}
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        self.refreshControl?.endRefreshing()
    }

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
        
        if identifier == "PostCell" {
            cell.textNewsPost.text = postNewsList[indexPath.row].textNews
            cell.resetStateButtonShowMore()
            
            cell.textNewsPost.sizeToFit()
            let heightTextView = cell.textNewsPost.frame.size.height
            
            if heightTextView > 200.5 {
                cell.textNewsPost.adjustUITextViewHeightToDefault()
                cell.showMore.setTitle("Показать полностью", for: .normal)
            } else {
                cell.showMore.isHidden = true
            }
        }
        
        guard let imgUrl = URL(string: postNewsList[indexPath.row].imageNews) else {return cell}
        cell.imgNews.image = UIImage(systemName: "icloud.and.arrow.down")
        cell.imgNews.load(url: imgUrl)
        
        return cell
    }
    
    //MARK: - бесконечный скролл
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            isLoadingNews == false,
        let maxRow = indexPaths.map ({ $0.row }).max(),
            maxRow > (postNewsList.count - 3)
        else {return}
        
        isLoadingNews = true
        
        getNewsListSwiftyJSON.get(nextPageNews: nextNewsID) { [weak self] (nextNews, nextFromID) in
            guard let self = self else {return}
            let newsCount = self.postNewsList.count
            self.postNewsList.append(contentsOf: nextNews)
            
            let indexPaths = (newsCount..<(newsCount + nextNews.count))
                .map {IndexPath(row: $0, section: 0)}
            
            self.tableView.insertRows(at: indexPaths, with: .automatic)
            self.nextNewsID = nextFromID
            self.isLoadingNews = false
        }
    }

}
