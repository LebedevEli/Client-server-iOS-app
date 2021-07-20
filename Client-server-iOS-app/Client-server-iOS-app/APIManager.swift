//
//  APIManager.swift
//  vk-api
//
//  Created by Илья Лебедев on 20.07.2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class APIManager {
    
    static let shared = APIManager()
    
    private func configureFB() -> Firestore {
        
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(id: String, imageID: String, completion: @escaping (Feed?) -> Void) {
        let db = configureFB()
        db.collection("posts").document(id).getDocument() { document, error in
            guard error == nil else {completion(nil); return}
            self.getImage(id: imageID) { image in
                let post = Feed(name: document?.get("name") as! String,
                                avatar: image,
                                date: document?.get("date") as! String,
                                text: document?.get("text") as! String,
                                textImage: image)
                completion(post)
            }
        }
    }
    
    func getImage(id: String, completion: @escaping (UIImage) -> Void ) {
    
    let storage = Storage.storage()
    let reference = storage.reference()
        let pathRef = reference.child("pictures")
        
        var image: UIImage = UIImage(named: "2")!
        
        let fileRef = pathRef.child(id + ".jpeg")
        fileRef.getData(maxSize: 1024*1024) { data, error in
            guard error == nil else {completion(image); return}
            image = UIImage(data: data!)!
            completion(image)
        }
    }
    
}
