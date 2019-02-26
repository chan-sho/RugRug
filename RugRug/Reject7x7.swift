//
//  Reject7x7.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/30.
//  Copyright © 2019 高野翔. All rights reserved.
//
// 【UserDefaults管理】"Reject7x7Flag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"Caution7x7Flag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectUser7x7Flag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag(Userブロック用)

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import ESTabBarController


class Reject7x7: UIViewController {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideButton.layer.cornerRadius = 30.0
        reportButton.layer.cornerRadius = 30.0
        blockButton.layer.cornerRadius = 30.0

        //userDefaultsの初期値設定（念の為）
        userDefaults.register(defaults: ["Reject7x7Flag" : "NO", "Caution7x7Flag" : "NO", "RejectUser7x7Flag" : "NO"])
    }
    

    @IBAction func hideButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "Reject7x7Flag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    @IBAction func reportButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "Caution7x7Flag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    @IBAction func blockButton(_ sender: Any) {
        userDefaults.set("YES", forKey: "RejectUser7x7Flag")
        userDefaults.synchronize()
        showAlertWithVC()
    }
    
    
    //最終確認ポップアップページを出す
    func showAlertWithVC(){
        
        let CautionFlag :String = userDefaults.string(forKey: "Caution7x7Flag")!
        if CautionFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "この7x7が好ましくない内容を含む事を管理人に報告しますか？\n\nDo you report to RugRug manager ?", aCancelBtnTitle: "キャンセル / Cancel", aOtherBtnTitle: "報告 / Report") { (index, title) in
                print(index,title)
                
            }
        }
        
        let RejectFlag :String = userDefaults.string(forKey: "Reject7x7Flag")!
        if RejectFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今後、この7x7を貴方の投稿一覧に表示しない様にしますか？\n\nDo you hide this 7x7 ?", aCancelBtnTitle: "キャンセル / Cancel", aOtherBtnTitle: "非表示 / Hide") { (index, title) in
                print(index,title)
            }
        }
        
        let RejectUserFlag :String = userDefaults.string(forKey: "RejectUser7x7Flag")!
        if RejectUserFlag == "YES" {
            AJAlertController.initialization().showAlert(aStrMessage: "今後、この投稿者の全ての7x7をブロックしますか？\n\nDo you block all 7x7s of this poster ?", aCancelBtnTitle: "キャンセル / Cancel", aOtherBtnTitle: "ブロック / Block") { (index, title) in
                print(index,title)
            }
        }
    }
    
}
