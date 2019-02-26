//
//  Reject.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/13.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"RejectDataFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectUserFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag(Userブロック用)


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController


class Reject: UIViewController {

    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rejectButton.layer.cornerRadius = 30.0
        reportButton.layer.cornerRadius = 30.0
        blockUserButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        rejectButton.isExclusiveTouch = true
        reportButton.isExclusiveTouch = true
        blockUserButton.isExclusiveTouch = true

        //userDefaultsの初期値設定（念の為）
        userDefaults.register(defaults: ["RejectDataFlag" : "NO", "CautionDataFlag" : "NO", "RejectUserFlag" : "NO"])
    }
    
    
    @IBAction func rejectButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "RejectDataFlag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    @IBAction func reportButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "CautionDataFlag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    @IBAction func blockUserButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "RejectUserFlag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    //最終確認ポップアップページを出す
    func showAlertWithVC(){
        
        let CautionFlag :String = userDefaults.string(forKey: "CautionDataFlag")!
        if CautionFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "この投稿が好ましくない内容を含む事を管理人に報告しますか？", aCancelBtnTitle: "キャンセル", aOtherBtnTitle: "管理人に報告") { (index, title) in
                print(index,title)
                
            }
        }
        
        let RejectFlag :String = userDefaults.string(forKey: "RejectDataFlag")!
        if RejectFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今後、この投稿を貴方の投稿一覧に表示しない様にしますか？", aCancelBtnTitle: "キャンセル", aOtherBtnTitle: "今後表示しない") { (index, title) in
                print(index,title)
            }
        }
        
        let RejectUserFlag :String = userDefaults.string(forKey: "RejectUserFlag")!
        if RejectUserFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今後、この投稿者の全ての投稿をブロックしますか？\n（＝この投稿者をブロック）", aCancelBtnTitle: "キャンセル", aOtherBtnTitle: "投稿者ブロック") { (index, title) in
                print(index,title)
            }
        }
    }
    
}
