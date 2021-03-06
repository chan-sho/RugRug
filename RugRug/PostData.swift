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
// 【UserDefaults管理】"RejectUserFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag(Userブロック用)
// 【UserDefaults管理】"RejectUserId"= 投稿画面で「リジェクト／管理」を押した投稿者のID
// 【UserDefaults管理】"RejectIdArray"= 投稿画面で「リジェクト／管理」を押した投稿のIDをまとめた配列
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataId"= 投稿画面で「報告」を押した投稿のID
// 【UserDefaults管理】"UserPhotoURLFlag"= 投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"UserPhotoURL"= 投稿者のFacebookページを検索するためのURL
// 【UserDefaults管理】"UserPhotoName"= 投稿者のFacebookページを検索するためのName
// 【UserDefaults管理】"ContactRequestPost"= コンタクト通知をした対象の投稿ID
// 【UserDefaults管理】"ContactRequestUserID"= コンタクト通知をした相手のユーザーID
// 【UserDefaults管理】"RequestedPostID"= Info画面の「この時チェックされた投稿」ボタンに紐づく投稿ID
// 【UserDefaults管理】"ChatDataId"= チャットをしたい対象の投稿ID
// 【UserDefaults管理】"ChatRequestFlag"= コンタクト通知一覧で、投稿者プロフィール画像を押した事を確認するFlag
// 【UserDefaults管理】"PostType"= PostのTypeを判別するコード
// 【UserDefaults管理】"MatchSettingFlag"= Match-Settingが完了しているかどうかの判別Flag
// 【UserDefaults管理】"MatchRequest"= Match-Settingで繋がりたいユーザーの希望内容
// 【UserDefaults管理】"MatchInterested"= Match-Settingで興味があるジャンルの内容
// 【UserDefaults管理】"MatchPosition"= Match-Settingで設定したポジション
// 【UserDefaults管理】"MatchDetail"= Match-Settingで設定したポジションの詳細
// 【UserDefaults管理】"MatchID"= Match-SettingでFirebaseに投稿した際の自身のID
// 【UserDefaults管理】"MatchYESArray"= Match-SwipeでYESにした投稿IDのまとめ
// 【UserDefaults管理】"MatchNoArray"= Match-SwipeでNOにした投稿IDのまとめ
// 【UserDefaults管理】"MatchConfirmID"= Match-SwipeでMatchYesまたはMatchNoを判断するための対象投稿ID
// 【UserDefaults管理】"MatchNextTime"= 次回Match-Swipeが利用可能になる時刻


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
    var ChatRequest: String?
    var contentsURL: String?
    var new7x7: [String]?
    var postType: String?
    var Request: String?
    var Interested: String?
    var Position: Int?
    var Detail: Int?
    var MatchYes: [String] = []
    
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.userID = valueDictionary["userID"] as? String
        self.name = valueDictionary["name"] as? String
        self.category = valueDictionary["category"] as? String
        self.contents = valueDictionary["contents"] as? String
        self.contentsURL = valueDictionary["contentsURL"] as? String
        
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
        self.ChatRequest = valueDictionary["ChatRequest"] as? String
        self.new7x7 = valueDictionary["7×7"] as? [String]
        self.postType = valueDictionary["postType"] as? String
        
        self.Request = valueDictionary["Request"] as? String
        self.Interested = valueDictionary["Interested"] as? String
        self.Position = valueDictionary["Position"] as? Int
        self.Detail = valueDictionary["Detail"] as? Int
        self.MatchYes = valueDictionary["Match-YES"] as? [String] ?? []
        
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
