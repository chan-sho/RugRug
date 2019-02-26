//
//  Request.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class Request: UIViewController, UITextFieldDelegate, UITextViewDelegate  {

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var RugRugPhoto: UIImageView!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var userMail: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var referenceButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contents.delegate = self
        userMail.delegate = self
        
        // 枠のカラー
        contents.layer.borderColor = UIColor.gray.cgColor
        userMail.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        contents.layer.borderWidth = 0.5
        userMail.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        contents.layer.cornerRadius = 10.0
        contents.layer.masksToBounds = true
        userMail.layer.cornerRadius = 10.0
        userMail.layer.masksToBounds = true
        
        submitButton.layer.cornerRadius = 30.0
        referenceButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        submitButton.isExclusiveTouch = true
        referenceButton.isExclusiveTouch = true
        
        self.RugRugPhoto.clipsToBounds = true
        self.RugRugPhoto.layer.cornerRadius = 35.0
        self.RugRugPhoto.layer.borderColor = UIColor.lightGray.cgColor
        self.RugRugPhoto.layer.borderWidth = 1.0
        
        
        //ログインユーザーのプロフィール画像をロード
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            userName.text = "\(currentUser!.displayName ?? "")さん"
            
            let userProfileurl = (Auth.auth().currentUser?.photoURL?.absoluteString)! + "?width=140&height=140"
            
            if userProfileurl != "" {
                let url = URL(string: "\(userProfileurl)")
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        self.userPhoto.image = UIImage(data: data!)
                        self.userPhoto.clipsToBounds = true
                        self.userPhoto.layer.cornerRadius = 35.0
                        self.userPhoto.layer.borderColor = UIColor.white.cgColor
                        self.userPhoto.layer.borderWidth = 1.0
                    }
                }).resume()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Returnボタンを押した際にキーボードを消す（※TextViewには設定できない。改行できなくなる為＾＾）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userMail.resignFirstResponder()
        return true
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contents.resignFirstResponder()
        userMail.resignFirstResponder()
    }
    

    @IBAction func submitButton(_ sender: Any) {
        if contents.text == "" {
            SVProgressHUD.showError(withStatus: "ご意見・ご要望の記載が空白です。\nご確認下さい。")
        }
        else {
            //FireBase上に辞書型データで残す処理
            //postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            //メールアドレスが空白だった際のデータ準備
            if userMail.text == "" {
                userMail.text = "e-mail記載なし"
            }
            
            //**重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const2.PostPath2)
            let postDic = ["userID": Auth.auth().currentUser!.uid, "time": String(time), "name": name!, "requestTextField": String(contents.text!), "requestUserEmail": userMail.text!, "answerTextField": "", "answerCategory": "", "answerFlag": ""] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            //各テキストデータの初期化
            contents.text = ""
            userMail.text = ""
            
            SVProgressHUD.showSuccess(withStatus: "\(name!)さん\n\n貴重なご意見、本当にありがとうございました！\nこれからも頑張ってより良いRugRugにしていきますので、どうか宜しくお願い致します！")
        }
    }
    
    
    @IBAction func referenceButton(_ sender: Any) {
    }
    
}
