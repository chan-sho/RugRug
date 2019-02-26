//
//  New7x7.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/28.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class New7x7: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var T0: UITextField!
    @IBOutlet weak var T1: UITextField!
    @IBOutlet weak var T2: UITextField!
    @IBOutlet weak var T3: UITextField!
    @IBOutlet weak var T4: UITextField!
    @IBOutlet weak var T5: UITextField!
    @IBOutlet weak var T6: UITextField!
    @IBOutlet weak var T7: UITextField!
    @IBOutlet weak var T8: UITextField!
    @IBOutlet weak var T9: UITextField!
    @IBOutlet weak var T10: UITextField!
    @IBOutlet weak var T11: UITextField!
    @IBOutlet weak var T12: UITextField!
    @IBOutlet weak var T13: UITextField!
    @IBOutlet weak var T14: UITextField!
    @IBOutlet weak var T15: UITextField!
    @IBOutlet weak var T16: UITextField!
    @IBOutlet weak var T17: UITextField!
    @IBOutlet weak var T18: UITextField!
    @IBOutlet weak var T19: UITextField!
    @IBOutlet weak var T20: UITextField!
    @IBOutlet weak var T21: UITextField!
    @IBOutlet weak var T22: UITextField!
    @IBOutlet weak var T23: UITextField!
    @IBOutlet weak var T24: UITextField!
    @IBOutlet weak var T25: UITextField!
    @IBOutlet weak var T26: UITextField!
    @IBOutlet weak var T27: UITextField!
    @IBOutlet weak var T28: UITextField!
    @IBOutlet weak var T29: UITextField!
    @IBOutlet weak var T30: UITextField!
    @IBOutlet weak var T31: UITextField!
    @IBOutlet weak var T32: UITextField!
    @IBOutlet weak var T33: UITextField!
    @IBOutlet weak var T34: UITextField!
    @IBOutlet weak var T35: UITextField!
    @IBOutlet weak var T36: UITextField!
    @IBOutlet weak var T37: UITextField!
    @IBOutlet weak var T38: UITextField!
    @IBOutlet weak var T39: UITextField!
    @IBOutlet weak var T40: UITextField!
    @IBOutlet weak var T41: UITextField!
    @IBOutlet weak var T42: UITextField!
    @IBOutlet weak var T43: UITextField!
    @IBOutlet weak var T44: UITextField!
    @IBOutlet weak var T45: UITextField!
    @IBOutlet weak var T46: UITextField!
    @IBOutlet weak var T47: UITextField!
    @IBOutlet weak var T48: UITextField!
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var newPostButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        T0.delegate = self
        T1.delegate = self
        T2.delegate = self
        T3.delegate = self
        T4.delegate = self
        T5.delegate = self
        T6.delegate = self
        T7.delegate = self
        T8.delegate = self
        T9.delegate = self
        T10.delegate = self
        T11.delegate = self
        T12.delegate = self
        T13.delegate = self
        T14.delegate = self
        T15.delegate = self
        T16.delegate = self
        T17.delegate = self
        T18.delegate = self
        T19.delegate = self
        T20.delegate = self
        T21.delegate = self
        T22.delegate = self
        T23.delegate = self
        T24.delegate = self
        T25.delegate = self
        T26.delegate = self
        T27.delegate = self
        T28.delegate = self
        T29.delegate = self
        T30.delegate = self
        T31.delegate = self
        T32.delegate = self
        T33.delegate = self
        T34.delegate = self
        T35.delegate = self
        T36.delegate = self
        T37.delegate = self
        T38.delegate = self
        T39.delegate = self
        T40.delegate = self
        T41.delegate = self
        T42.delegate = self
        T43.delegate = self
        T44.delegate = self
        T45.delegate = self
        T46.delegate = self
        T47.delegate = self
        T48.delegate = self
        
        newPostButton.layer.cornerRadius = 30.0
        
        //ログインユーザーのプロフィール画像をロード
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            userName.text = "\(currentUser!.displayName ?? "")-san's New 7×7 !!"
            
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
    

    // Returnボタンを押した際にキーボードを消す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        T0.resignFirstResponder()
        T1.resignFirstResponder()
        T2.resignFirstResponder()
        T3.resignFirstResponder()
        T4.resignFirstResponder()
        T5.resignFirstResponder()
        T6.resignFirstResponder()
        T7.resignFirstResponder()
        T8.resignFirstResponder()
        T9.resignFirstResponder()
        T10.resignFirstResponder()
        T11.resignFirstResponder()
        T12.resignFirstResponder()
        T13.resignFirstResponder()
        T14.resignFirstResponder()
        T15.resignFirstResponder()
        T16.resignFirstResponder()
        T17.resignFirstResponder()
        T18.resignFirstResponder()
        T19.resignFirstResponder()
        T20.resignFirstResponder()
        T21.resignFirstResponder()
        T22.resignFirstResponder()
        T23.resignFirstResponder()
        T24.resignFirstResponder()
        T25.resignFirstResponder()
        T26.resignFirstResponder()
        T27.resignFirstResponder()
        T28.resignFirstResponder()
        T29.resignFirstResponder()
        T30.resignFirstResponder()
        T31.resignFirstResponder()
        T32.resignFirstResponder()
        T33.resignFirstResponder()
        T34.resignFirstResponder()
        T35.resignFirstResponder()
        T36.resignFirstResponder()
        T37.resignFirstResponder()
        T38.resignFirstResponder()
        T39.resignFirstResponder()
        T40.resignFirstResponder()
        T41.resignFirstResponder()
        T42.resignFirstResponder()
        T43.resignFirstResponder()
        T44.resignFirstResponder()
        T45.resignFirstResponder()
        T46.resignFirstResponder()
        T47.resignFirstResponder()
        T48.resignFirstResponder()
        
        return true
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        T0.resignFirstResponder()
        T1.resignFirstResponder()
        T2.resignFirstResponder()
        T3.resignFirstResponder()
        T4.resignFirstResponder()
        T5.resignFirstResponder()
        T6.resignFirstResponder()
        T7.resignFirstResponder()
        T8.resignFirstResponder()
        T9.resignFirstResponder()
        T10.resignFirstResponder()
        T11.resignFirstResponder()
        T12.resignFirstResponder()
        T13.resignFirstResponder()
        T14.resignFirstResponder()
        T15.resignFirstResponder()
        T16.resignFirstResponder()
        T17.resignFirstResponder()
        T18.resignFirstResponder()
        T19.resignFirstResponder()
        T20.resignFirstResponder()
        T21.resignFirstResponder()
        T22.resignFirstResponder()
        T23.resignFirstResponder()
        T24.resignFirstResponder()
        T25.resignFirstResponder()
        T26.resignFirstResponder()
        T27.resignFirstResponder()
        T28.resignFirstResponder()
        T29.resignFirstResponder()
        T30.resignFirstResponder()
        T31.resignFirstResponder()
        T32.resignFirstResponder()
        T33.resignFirstResponder()
        T34.resignFirstResponder()
        T35.resignFirstResponder()
        T36.resignFirstResponder()
        T37.resignFirstResponder()
        T38.resignFirstResponder()
        T39.resignFirstResponder()
        T40.resignFirstResponder()
        T41.resignFirstResponder()
        T42.resignFirstResponder()
        T43.resignFirstResponder()
        T44.resignFirstResponder()
        T45.resignFirstResponder()
        T46.resignFirstResponder()
        T47.resignFirstResponder()
        T48.resignFirstResponder()
    }

    
    @IBAction func newPostButton(_ sender: Any) {
        let new7x7 = ["\(T0.text ?? "")","\(T1.text ?? "")","\(T2.text ?? "")","\(T3.text ?? "")","\(T4.text ?? "")","\(T5.text ?? "")","\(T6.text ?? "")","\(T7.text ?? "")","\(T8.text ?? "")","\(T9.text ?? "")","\(T10.text ?? "")","\(T11.text ?? "")","\(T12.text ?? "")","\(T13.text ?? "")","\(T14.text ?? "")","\(T15.text ?? "")","\(T16.text ?? "")","\(T17.text ?? "")","\(T18.text ?? "")","\(T19.text ?? "")","\(T20.text ?? "")","\(T21.text ?? "")","\(T22.text ?? "")","\(T23.text ?? "")","\(T24.text ?? "")","\(T25.text ?? "")","\(T26.text ?? "")","\(T27.text ?? "")","\(T28.text ?? "")","\(T29.text ?? "")","\(T30.text ?? "")","\(T31.text ?? "")","\(T32.text ?? "")","\(T33.text ?? "")","\(T34.text ?? "")","\(T35.text ?? "")","\(T36.text ?? "")","\(T37.text ?? "")","\(T38.text ?? "")","\(T39.text ?? "")","\(T40.text ?? "")","\(T41.text ?? "")","\(T42.text ?? "")","\(T43.text ?? "")","\(T44.text ?? "")","\(T45.text ?? "")","\(T46.text ?? "")","\(T47.text ?? "")","\(T48.text ?? "")"]
        
        if new7x7 == ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""] {
            SVProgressHUD.showError(withStatus: "7×7の記載が空白です。\nご確認下さい。\n\nYour new 7×7 is empty. Please check")
        }
        else {
            // ImageViewから画像を取得する
            let imageData = userPhoto.image!.jpegData(compressionQuality: 0.5)
            let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
            // postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            // **重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const7.PostPath7)
            let postDic = ["userID": Auth.auth().currentUser!.uid, "7×7": new7x7, "userPhoto": imageString, "time": String(time), "name": name!] as [String : Any]
            postRef.childByAutoId().setValue(postDic)
            
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました！\nPosting complete !")
            
            // 画面を閉じてViewControllerに戻る
            dismiss(animated: true, completion: nil)
        }
    }
    
}
