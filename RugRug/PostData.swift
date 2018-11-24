//
//  PostData.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/24.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"InitialFlag"= Initial画面表示判定
// 【UserDefaults管理】"reviseDataId"= 投稿画面で「編集」を押した投稿のID


import UIKit
import Firebase
import FirebaseDatabase


class PostData: NSObject {
    
    var id: String?
    var userID: String?
    var name: String?
    var userPhoto: UIImage?
    var userPhotoString: String?
    var category: String?
    var contents: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var mySecret: [String] = []
    var mySecretSelected: Bool = false
    var EULAagreement: String?
    var requestTextField: String?
    var requestUserEmail: String?
    var answerTextField: String?
    var answerCategory: String?
    var answerFlag: String?
    
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.userID = valueDictionary["userID"] as? String
        self.name = valueDictionary["name"] as? String
        self.category = valueDictionary["category"] as? String
        self.contents = valueDictionary["contents"] as? String
        
        userPhotoString = valueDictionary["userPhoto"] as? String
        if userPhotoString != nil {
            userPhoto = UIImage(data: Data(base64Encoded: userPhotoString!, options: .ignoreUnknownCharacters)!)
        }
        
        self.EULAagreement = valueDictionary["EULAagreement"] as? String
        
        self.requestTextField = valueDictionary["requestTextField"] as? String
        self.requestUserEmail = valueDictionary["requestUserEmail"] as? String
        self.answerTextField = valueDictionary["answerTextField"] as? String
        self.answerCategory = valueDictionary["answerCategory"] as? String
        self.answerFlag = valueDictionary["answerFlag"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        if let mySecret = valueDictionary["mySecret"] as? [String] {
            self.mySecret = mySecret
        }
        
        for mySecretId in self.mySecret {
            if mySecretId == myId {
                self.mySecretSelected = true
                break
            }
            else {
                self.mySecretSelected = false
                break
            }
        }
    }
}
