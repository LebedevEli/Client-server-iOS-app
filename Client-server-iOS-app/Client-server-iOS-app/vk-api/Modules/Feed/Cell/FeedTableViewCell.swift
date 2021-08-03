//
//  FeedTableViewCell.swift
//  vk-api
//
//  Created by Илья Лебедев on 02.07.2021.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarUserFeed: AvatarView!
    @IBOutlet weak var nameUserFeed: UILabel!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var textNewsPost: UITextView!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var likesCount: LikeButtonControl!
    @IBOutlet weak var commentsCount: UIButton!
    @IBOutlet weak var repostsCount: UIButton!
    @IBOutlet weak var viewsCount: UIButton!
}
