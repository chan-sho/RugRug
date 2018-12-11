//
//  PostData.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/24.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"InitialFlag"= Initial画面表示判定
// 【UserDefaults管理】"reviseDataId"= 投稿画面で「編集」を押した投稿のID
// 【UserDefaults管理】"EULAagreement"= 利用規約に同意したかどうかの判定
// 【UserDefaults管理】"EULACheckFlag"= プライバシーポリシー・利用規約のページをきちんと開いた事を確認するFlag
// 【UserDefaults管理】"AccountDeleteFlag"= アカウント削除ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectDataFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectDataId"= 投稿画面で「リジェクト／管理」を押した投稿のID
// 【UserDefaults管理】"RejectIdArray"= 投稿画面で「リジェクト／管理」を押した投稿のIDをまとめた配列
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataId"= 投稿画面で「報告」を押した投稿のID
// 【UserDefaults管理】"UserPhotoURLFlag"= 投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"UserPhotoURL"= 投稿者のFacebookページを検索するためのURL
// 【UserDefaults管理】"UserPhotoName"= 投稿者のFacebookページを検索するためのName
// 【UserDefaults管理】"ContactRequestPost"= コンタクト通知をした対象の投稿ID
// 【UserDefaults管理】"ContactRequestUserID"= コンタクト通知をした相手のユーザーID
// 【UserDefaults管理】"RequestedPostID"= Info画面の「この時チェックされた投稿」ボタンに紐づく投稿ID


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
    var rejects: [String] = []
    var isRejected: Bool = false
    var EULAagreement: String?
    var requestTextField: String?
    var requestUserEmail: String?
    var answerTextField: String?
    var answerCategory: String?
    var answerFlag: String?
    var news1Photo: UIImage?
    var news1PhotoString: String?
    var AskUserID: String?
    var AskUserName: String?
    var AskUserURL: String?
    var RequestedUserID: String?
    var RequestedName: String?
    var RequestedPostID: String?
    
    
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
        
        news1PhotoString = valueDictionary["News1Photo"] as? String
        if news1PhotoString != nil {
            news1Photo = UIImage(data: Data(base64Encoded: news1PhotoString!, options: .ignoreUnknownCharacters)!)
        }
        
        self.EULAagreement = valueDictionary["EULAagreement"] as? String
        
        self.requestTextField = valueDictionary["requestTextField"] as? String
        self.requestUserEmail = valueDictionary["requestUserEmail"] as? String
        self.answerTextField = valueDictionary["answerTextField"] as? String
        self.answerCategory = valueDictionary["answerCategory"] as? String
        self.answerFlag = valueDictionary["answerFlag"] as? String
        
        self.AskUserID = valueDictionary["AskUserID"] as? String
        self.AskUserName = valueDictionary["AskUserName"] as? String
        self.AskUserURL = valueDictionary["AskUserURL"] as? String
        self.RequestedUserID = valueDictionary["RequestedUserID"] as? String
        self.RequestedName = valueDictionary["RequestedName"] as? String
        self.RequestedPostID = valueDictionary["RequestedPostID"] as? String
        
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
        
        if let rejects = valueDictionary["rejects"] as? [String] {
            self.rejects = rejects
        }
        
        for rejectId in self.rejects {
            if rejectId == myId {
                self.isRejected = true
                break
            }
            else {
                self.isRejected = false
                break
            }
        }
    }
}
