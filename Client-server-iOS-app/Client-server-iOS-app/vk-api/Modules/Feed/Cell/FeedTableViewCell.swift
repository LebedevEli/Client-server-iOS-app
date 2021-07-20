//
//  FeedTableViewCell.swift
//  vk-api
//
//  Created by Илья Лебедев on 02.07.2021.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarFeed: AvatarView!
    @IBOutlet weak var nameFeed: UILabel!
    @IBOutlet weak var dateFeed: UILabel!
    @IBOutlet weak var textFeed: UILabel!
    @IBOutlet weak var imageFeed: UIImageView!
}
