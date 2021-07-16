//
//  FriendsTableViewCell.swift
//  vk-api
//
//  Created by Илья Лебедев on 27.06.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameFriend: UILabel!
    
//    @IBOutlet weak var viewFriends: UIView! //Лишнюю вью добавил
//    @IBOutlet weak var backView: UIView!
    
//    var saveFriend: Friend?
//
//    func setup(){
//        avatarImage.layer.cornerRadius = CGFloat(self.frame.width / 2) //закругление аватарки
//        backView.layer.cornerRadius = CGFloat(self.frame.width / 2)  // закругление тени аватарки
//        backView.layer.shadowColor = UIColor.black.cgColor //цвет тени
//        backView.layer.shadowOffset = CGSize.zero //сдвиг тени по оси Х и Y
//        backView.layer.shadowRadius = 5 //размер тени
//        backView.layer.shadowOpacity = 0.8 //прозрачность тени
//    }
//
//    func clearCell(){
//        //очищаем ячейку
//        avatarImage.image = nil
//        nameFriend.text = nil
//        saveFriend = nil
//
//    }
//
//    func configureWithFriend(friend: Friend) {
//        nameFriend.text =
//        avatarImage.image = friend.avatar
//        saveFriend = friend
//    }
//
//    override func prepareForReuse() {
//        clearCell()
//    }
//
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        avatarImage.layer.cornerRadius = CGFloat(self.frame.width / 2)
//    }
//
}
