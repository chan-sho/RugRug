//
//  Revise.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/24.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class Revise: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
    @IBOutlet weak var categoryRevised: UITextField!
    @IBOutlet weak var contentsRevised: UITextView!
    @IBOutlet weak var contentsURLRevised: UITextField!
    @IBOutlet weak var reviseDoneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var reviseData : String?
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryRevised.delegate = self
        contentsRevised.delegate = self
        contentsURLRevised.delegate = self
        
        // 枠のカラー
        categoryRevised.layer.borderColor = UIColor.gray.cgColor
        contentsRevised.layer.borderColor = UIColor.gray.cgColor
        contentsURLRevised.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        categoryRevised.layer.borderWidth = 0.5
        contentsRevised.layer.borderWidth = 0.5
        contentsURLRevised.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        categoryRevised.layer.cornerRadius = 10.0
        categoryRevised.layer.masksToBounds = true
        contentsRevised.layer.cornerRadius = 10.0
        contentsRevised.layer.masksToBounds = true
        contentsURLRevised.layer.cornerRadius = 10.0
        contentsURLRevised.layer.masksToBounds = true
        
        reviseDoneButton.layer.cornerRadius = 30.0
        deleteButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        reviseDoneButton.isExclusiveTouch = true
        deleteButton.isExclusiveTouch = true
        cancelButton.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //念のため（※userDefaultsの更新タイミングが遅かった場合のために）
    override func viewWillAppear(_ animated: Bool) {
        reviseData = userDefaults.string(forKey: "reviseDataId")
        
        if reviseData == "" {
            SVProgressHUD.showError(withStatus: "エラーが発生しました！。\nお手数ですが、再度最初から手続きをお願いします。")
            return
        }
        //reviseDataに対象の投稿ナンバーが入っている場合
        else {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("posts").child("\(self.reviseData!)").child("userID")
            
            //  FirebaseからobserveSingleEventで1回だけデータ検索
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String
                
                let uid = Auth.auth().currentUser?.uid
                if uid == value {
                    //Firebaseから該当データを抽出
                    let refToRevise = Database.database().reference().child("posts").child("\(self.reviseData!)")
                    
                    refToRevise.observeSingleEvent(of: .value, with: { (snapshot) in
                        var valueToRevise = snapshot.value as! [String: AnyObject]
                        //各Textに保存
                        self.categoryRevised.text = valueToRevise["category"] as? String
                        self.contentsRevised.text = valueToRevise["contents"] as? String
                        self.contentsURLRevised.text = valueToRevise["contentsURL"] as? String
                    })
                }
                else {
                    SVProgressHUD.showError(withStatus: "エラーが発生しました！\nお手数ですが、再度最初から手続きをお願いします。")
                    return
                }
                
            }) { (error) in
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: "エラーが発生しました！\nお手数ですが、再度最初から手続きをお願いします。")
                return
            }
        }
    }
    
    
    // Returnボタンを押した際にキーボードを消す（※TextViewには設定できない。改行できなくなる為＾＾）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryRevised.resignFirstResponder()
        contentsURLRevised.resignFirstResponder()
        return true
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        categoryRevised.resignFirstResponder()
        contentsRevised.resignFirstResponder()
        contentsURLRevised.resignFirstResponder()
    }

    
    @IBAction func reviseDoneButton(_ sender: Any) {
        //念の為もう一回userDefaultsから取得しておく
        reviseData = userDefaults.string(forKey: "reviseDataId")
        
        if categoryRevised.text == ""{
            let Data = ["category": "(題名なし)", "contents": "\(contentsRevised.text ?? "")", "contentsURL": "\(contentsURLRevised.text ?? "")"]
            
            //Firebaseから該当データを選択し、データの各項目をアップデート
            let refToReviseData = Database.database().reference().child("posts").child("\(reviseData!)")
            refToReviseData.updateChildValues(Data)
        }
        else{
            let Data = ["category": "\(categoryRevised.text!)", "contents": "\(contentsRevised.text ?? "")", "contentsURL": "\(contentsURLRevised.text ?? "")"]
            
            //Firebaseから該当データを選択し、データの各項目をアップデート
            let refToReviseData = Database.database().reference().child("posts").child("\(reviseData!)")
            refToReviseData.updateChildValues(Data)
        }
        
        // 画面を閉じてViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        //念の為もう一回userDefaultsから取得しておく
        reviseData = userDefaults.string(forKey: "reviseDataId")
        //Firebaseからデータを削除
        let refOfDelete = Database.database().reference().child("posts").child("\(self.reviseData!)")
        refOfDelete.removeValue()
                    
        SVProgressHUD.showSuccess(withStatus: "対象の投稿が削除されました")
                    
        // 画面を閉じてViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }
    
}
