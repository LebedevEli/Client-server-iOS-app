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
        
        subNotificationRealm()
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
    
    lazy var imageCache = ImageCache(container: self.collectionView)
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosFriendCell", for: indexPath) as! PhotoCollectionViewCell
        
//        if let imgUrl = URL(string: collectionPhotos[indexPath.row].photo) {
//            let photo = ImageResource(downloadURL: imgUrl)
//            cell.friendPhotoImage.kf.setImage(with: photo)
//
//        }
        let imgUrl = collectionPhotos[indexPath.row].photo
        cell.friendPhotoImage.image = imageCache.getPhoto(at: indexPath, url: imgUrl)
        
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
        guard collectionPhotos.count != 0 else {return}
        collectionView.reloadData()
    }
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUserPhoto"{
            
            guard let photosFriend = segue.destination as? FriendsPhotosViewController else { return }
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                photosFriend.allPhotos = collectionPhotos
                photosFriend.countCurentPhoto = indexPath.row
            }
        }
    }
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}
