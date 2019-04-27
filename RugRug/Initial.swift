//
//  Initial.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"InitialFlag"= Initial画面表示判定
// 【UserDefaults管理】"EULAagreement"= 利用規約に同意したかどうかの判定

import UIKit

class Initial: UIViewController {
    
    
    @IBOutlet weak var initialBackGround: UIImageView!
    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    var EULAagreement : String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠のカラー
        label1.layer.borderColor = UIColor.gray.cgColor
        label2.layer.borderColor = UIColor.gray.cgColor
        label3.layer.borderColor = UIColor.gray.cgColor
        label4.layer.borderColor = UIColor.gray.cgColor
        label5.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        label1.layer.borderWidth = 0.5
        label2.layer.borderWidth = 0.5
        label3.layer.borderWidth = 0.5
        label4.layer.borderWidth = 0.5
        label5.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        label1.layer.cornerRadius = 10.0
        label1.layer.masksToBounds = true
        label2.layer.cornerRadius = 10.0
        label2.layer.masksToBounds = true
        label3.layer.cornerRadius = 10.0
        label3.layer.masksToBounds = true
        label4.layer.cornerRadius = 10.0
        label4.layer.masksToBounds = true
        label5.layer.cornerRadius = 10.0
        label5.layer.masksToBounds = true
        
        goToLoginButton.layer.cornerRadius = 30.0
        goToLoginButton.layer.borderColor = UIColor.blue.cgColor
        goToLoginButton.layer.borderWidth = 0.0
        
        //利用規約同意の判別要素
        EULAagreement = userDefaults.string(forKey: "EULAagreement")
        
        //ログイン後に「新メンバーオリエンテーションを再度見る」を押したユーザー向けの処理
        if EULAagreement == "YES" {
            goToLoginButton.setTitle("「ホーム画面」に戻る", for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //EULA同意画面のポップアップページを出す
    func showAlertWithVC(){
        AJAlertController.initialization().showAlert(aStrMessage: "RugRugをダウンロード頂き、\n本当にありがとうございます！\n\nご利用頂くにあたり必ず【規約を確認】から「プライバシーポリシー」「利用規約」をご確認下さい。\n皆様の大切な個人情報に関する記載がございますのでどうかよろしくお願い致します。\n\n内容をご確認の上で、\n以下選択ください。", aCancelBtnTitle: "規約を確認", aOtherBtnTitle: "同意する") { (index, title) in
            print(index,title)
        }
    }
    
    
    @IBAction func goToLoginButton(_ sender: Any) {
        
        //利用規約に同意していない場合：
        if EULAagreement == "NO" {
            showAlertWithVC()
            return
        }
        //ログイン後に「新メンバーオリエンテーションを再度見る」を押したユーザー向けの処理
        else {
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    

}
