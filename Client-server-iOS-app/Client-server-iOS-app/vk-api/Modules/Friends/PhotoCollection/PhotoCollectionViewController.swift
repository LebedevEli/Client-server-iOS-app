//
//  PhotoCollectionViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 24.06.2021.
//

import UIKit
import Kingfisher
import RealmSwift


class PhotoCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotosFromRealm()
        GetPhotosFriend().loadData(ownerID)
    }
    
    var realm: Realm = {
        let configurateRealm = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: configurateRealm)
        return realm
    }()
    
    lazy var photosFromRealm: Results<Photo> = {
        return realm.objects(Photo.self).filter("ownerID == %@", ownerID)
    }()
    
    var notificationToken: NotificationToken?
    
    var ownerID = ""
    var collectionPhotos: [Photo] = []
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosFriendCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let imgUrl = URL(string: collectionPhotos[indexPath.row].photo) {
            let photo = ImageResource(downloadURL: imgUrl) //работает через Kingfisher
            cell.friendPhotoImage.kf.setImage(with: photo) //работает через Kingfisher
            
            //cell.photosFrienndImage.load(url: imgUrl)  // работает через extension UIImageView
        }
        
        return cell
    }
    
    //MARK: - Func
    
    private func subNotificationRealm() {
        notificationToken = photosFromRealm.observe({ [weak self] changes in
            switch changes {
            case .initial:
                self?.loadPhotosFromRealm()
            case .update:
                self?.loadPhotosFromRealm()
            case let .error(error):
                print(error)
            }
        })
    }
    
    func loadPhotosFromRealm() {
        collectionPhotos = Array(photosFromRealm)
        guard collectionPhotos.count != 0 else {return} // проверка реалм на содержимое
        collectionView.reloadData()
    }
    
    // MARK: - segue
    // переход на контроллер с отображением крупной фотографии
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUserPhoto"{
            // ссылка объект на контроллер с которого переход
            guard let photosFriend = segue.destination as? FriendsPhotosViewController else { return }
            
            // индекс нажатой ячейки
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                photosFriend.allPhotos = collectionPhotos //фотки
                photosFriend.countCurentPhoto = indexPath.row // можно указать (indexPath[0][1]) или использовать (?.first) как сделано выше
            }
        }
    }
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}
