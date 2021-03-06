//
//  Setting.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"AccountDeleteFlag"= アカウント削除ボタンを押した後の同意確認をするFlag


import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD


class Setting: UIViewController {

    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var acconutDeleteButton: UIButton!
    @IBOutlet weak var RugRugPhoto: UIImageView!
    
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportButton.layer.cornerRadius = 30.0
        logOutButton.layer.cornerRadius = 30.0
        acconutDeleteButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        reportButton.isExclusiveTouch = true
        logOutButton.isExclusiveTouch = true
        acconutDeleteButton.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //アカウント削除確認画面のポップアップページを出す
    func showAlertWithVC(){
        AJAlertController.initialization().showAlert(aStrMessage: "RugRugをご愛顧頂き、\n本当にありがとうございます！\n\nアカウント削除が完了すると投稿データを含む全てのデータを変更できません。残したくない投稿データはご自身で必ず削除をお願い致します。\n\n（※同一のFacebookアカウントで再登録頂きましてもデータは復元致しません。）\n\n上記内容をご確認の上で、\n以下選択ください。\n\nOnce delete your account, every data will be deleted immediately from data server.\nAre you OK ?", aCancelBtnTitle: "キャンセル/Cancel", aOtherBtnTitle: "退会/Delete") { (index, title) in
            print(index,title)
        }
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()
        // Login画面へ遷移
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(login!, animated: true, completion: nil)
    }
    
    
    @IBAction func accountDeleteButton(_ sender: Any) {
        //アカウント削除のボタンを押した事をFlagに反映("NO" → "YES")
        userDefaults.set("YES", forKey: "AccountDeleteFlag")
        userDefaults.synchronize()
        print("アカウント削除ボタンが押された！：AccountDeleteFlag = 「YES」に変更")
        
        showAlertWithVC()
    }
    
}
