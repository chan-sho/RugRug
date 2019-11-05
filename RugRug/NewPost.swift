//
//  NewPost.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/24.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"PostType"= PostのTypeを判別するコード


import UIKit
import ESTabBarController
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class NewPost: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var contentsURL: UITextField!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    var postType : String?
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        category.delegate = self
        contents.delegate = self
        contentsURL.delegate = self
        
        // 枠のカラー
        category.layer.borderColor = UIColor.gray.cgColor
        contents.layer.borderColor = UIColor.gray.cgColor
        contentsURL.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        category.layer.borderWidth = 0.5
        contents.layer.borderWidth = 0.5
        contentsURL.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        category.layer.cornerRadius = 10.0
        category.layer.masksToBounds = true
        contents.layer.cornerRadius = 10.0
        contents.layer.masksToBounds = true
        contentsURL.layer.cornerRadius = 10.0
        contentsURL.layer.masksToBounds = true
        
        newPostButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        newPostButton.isExclusiveTouch = true
        cancelButton.isExclusiveTouch = true
        
        //postTypeの更新
        postType = userDefaults.string(forKey: "PostType")
        print("PostTypeの確認＝\(String(describing: (postType)))")
        
        //ログインユーザーのプロフィール画像をロード
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        //postTypeの更新（念の為）
        postType = userDefaults.string(forKey: "PostType")
        print("PostTypeの確認＝\(String(describing: (postType)))")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Returnボタンを押した際にキーボードを消す（※TextViewには設定できない。改行できなくなる為＾＾）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        category.resignFirstResponder()
        contentsURL.resignFirstResponder()
        return true
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        category.resignFirstResponder()
        contents.resignFirstResponder()
        contentsURL.resignFirstResponder()
    }
    
    
    @IBAction func newPostButton(_ sender: Any) {
        
        if contents.text == "" {
            SVProgressHUD.showError(withStatus: "投稿内容の記載が空白です。\nご確認下さい。\n\nContent is Blank")
        }
        else {
        // ImageViewから画像を取得する
        let imageData = userPhoto.image!.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        // postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        let EULAagreement :String = userDefaults.string(forKey: "EULAagreement")!
        
        if category.text == ""{
            category.text = "(題名なし)"
        }
        
        // **重要** 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath)
            let postDic = ["userID": Auth.auth().currentUser!.uid, "category": category.text!, "contents": contents.text!, "contentsURL": contentsURL.text!, "userPhoto": imageString, "time": String(time), "name": name!, "EULAagreement": EULAagreement, "postType": postType!] as [String : Any]
        postRef.childByAutoId().setValue(postDic)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました！\nCompleted !")
        
        // 画面を閉じてViewControllerに戻る
        dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
