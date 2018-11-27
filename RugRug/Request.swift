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
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        submitButton.isExclusiveTouch = true
        referenceButton.isExclusiveTouch = true
        
        self.RugRugPhoto.clipsToBounds = true
        self.RugRugPhoto.layer.cornerRadius = 35.0
        self.RugRugPhoto.layer.borderColor = UIColor.gray.cgColor
        self.RugRugPhoto.layer.borderWidth = 0.5
        
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
    }
    
    
    @IBAction func referenceButton(_ sender: Any) {
    }
    
}
