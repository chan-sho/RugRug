//
//  Match-Setting.swift
//  RugRug
//
//  Created by 高野翔 on 2019/03/19.
//  Copyright © 2019 高野翔. All rights reserved.
//
// 【UserDefaults管理】"MatchSettingFlag"= Match-Settingが完了しているかどうかの判別Flag
// 【UserDefaults管理】"MatchRequest"= Match-Settingで繋がりたいユーザーの希望内容
// 【UserDefaults管理】"MatchInterested"= Match-Settingで興味があるジャンルの内容
// 【UserDefaults管理】"MatchPosition"= Match-Settingで設定したポジション
// 【UserDefaults管理】"MatchDetail"= Match-Settingで設定したポジションの詳細
// 【UserDefaults管理】"MatchID"= Match-SettingでFirebaseに投稿した際のID

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class Match_Setting: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var matchRequest: UITextView!
    @IBOutlet weak var interestedContents: UITextField!
    @IBOutlet weak var positionSegment: UISegmentedControl!
    @IBOutlet weak var detailSegment: UISegmentedControl!
    @IBOutlet weak var setButton: UIButton!
    
    // categoryTextにPickerを実装する準備
    var pickerView: UIPickerView = UIPickerView()
    let list = ["(選択してください)", "本気でラグビーしたい", "エンジョイレベルで楽しく", "一緒に観戦したい", "飲み会で盛り上がりたい", "ビジネスマッチング"]
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchRequest.delegate = self
        interestedContents.delegate = self
        
        // 枠のカラー
        matchRequest.layer.borderColor = UIColor.gray.cgColor
        interestedContents.layer.borderColor = UIColor.gray.cgColor
        // 枠の幅
        matchRequest.layer.borderWidth = 0.5
        interestedContents.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        matchRequest.layer.cornerRadius = 10.0
        matchRequest.layer.masksToBounds = true
        interestedContents.layer.cornerRadius = 10.0
        interestedContents.layer.masksToBounds = true
        
        setButton.layer.cornerRadius = 30.0
        
        self.positionSegment.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold)],
                                                     for: .normal)
        self.detailSegment.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold)],
                                                    for: .normal)
        positionSegment.tintColor = UIColor(red: 115/255, green: 252/255, blue: 214/255, alpha: 1.0)
        detailSegment.tintColor = UIColor(red: 115/255, green: 252/255, blue: 214/255, alpha: 1.0)

        //初期設定が完了している場合の各項目へのデータ反映
        let check1 = userDefaults.string(forKey: "MatchRequest")
        let check2 = userDefaults.string(forKey: "MatchInterested")
        if check1 != "" {
            self.matchRequest.text = userDefaults.string(forKey: "MatchRequest")
        }
        if check2 != "" {
            self.interestedContents.text = userDefaults.string(forKey: "MatchInterested")
        }
        
        //選択されているセグメントのインデックス
        positionSegment.selectedSegmentIndex = userDefaults.integer(forKey: "MatchPosition")
        detailSegment.selectedSegmentIndex = userDefaults.integer(forKey: "MatchDetail")
        
        //選択されているセグメントのインデックス
        let selectedIndex = positionSegment.selectedSegmentIndex
        
        if selectedIndex == 0 {
            detailSegment.setTitle("PR", forSegmentAt: 0)
            detailSegment.setTitle("HO", forSegmentAt: 1)
            detailSegment.setTitle("LO", forSegmentAt: 2)
            detailSegment.setTitle("FL", forSegmentAt: 3)
            detailSegment.setTitle("8", forSegmentAt: 4)
        }
        else if selectedIndex == 1 {
            detailSegment.setTitle("SH", forSegmentAt: 0)
            detailSegment.setTitle("SO", forSegmentAt: 1)
            detailSegment.setTitle("CTB", forSegmentAt: 2)
            detailSegment.setTitle("WTB", forSegmentAt: 3)
            detailSegment.setTitle("FB", forSegmentAt: 4)
        }
        else if selectedIndex == 2 {
            detailSegment.setTitle("監督", forSegmentAt: 0)
            detailSegment.setTitle("コーチ", forSegmentAt: 1)
            detailSegment.setTitle("マネ", forSegmentAt: 2)
            detailSegment.setTitle("庶務", forSegmentAt: 3)
            detailSegment.setTitle("分析", forSegmentAt: 4)
            
        }
        else if selectedIndex == 3 {
            detailSegment.setTitle("やる派", forSegmentAt: 0)
            detailSegment.setTitle("観る派", forSegmentAt: 1)
            detailSegment.setTitle("飲み派", forSegmentAt: 2)
            detailSegment.setTitle("熱狂的", forSegmentAt: 3)
            detailSegment.setTitle("にわか", forSegmentAt: 4)
        }
        
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
        
        
        // categoryTextにPickerを実装する準備
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(Match_Setting.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(Match_Setting.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.interestedContents.inputView = pickerView
        self.interestedContents.inputAccessoryView = toolbar
    }
    
    
    // Returnボタンを押した際にキーボードを消す（※TextViewには設定できない。改行できなくなる為＾＾）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        interestedContents.resignFirstResponder()
        return true
    }
    
    
    // テキスト以外の場所をタッチした際にキーボードを消す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        interestedContents.resignFirstResponder()
        matchRequest.resignFirstResponder()
    }

    
    // categoryTextにPickerを実装する
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.interestedContents.text = list[row]
    }
    
    @objc func cancel() {
        self.interestedContents.text = ""
        self.interestedContents.endEditing(true)
    }
    
    @objc func done() {
        self.interestedContents.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //textFieldにPicker以外の値を入れられないようにする
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    
    @IBAction func positionSegment(_ sender: Any) {
        //選択されているセグメントのインデックス
        let selectedIndex = positionSegment.selectedSegmentIndex
        
        if selectedIndex == 0 {
            detailSegment.setTitle("PR", forSegmentAt: 0)
            detailSegment.setTitle("HO", forSegmentAt: 1)
            detailSegment.setTitle("LO", forSegmentAt: 2)
            detailSegment.setTitle("FL", forSegmentAt: 3)
            detailSegment.setTitle("8", forSegmentAt: 4)
        }
        else if selectedIndex == 1 {
            detailSegment.setTitle("SH", forSegmentAt: 0)
            detailSegment.setTitle("SO", forSegmentAt: 1)
            detailSegment.setTitle("CTB", forSegmentAt: 2)
            detailSegment.setTitle("WTB", forSegmentAt: 3)
            detailSegment.setTitle("FB", forSegmentAt: 4)
        }
        else if selectedIndex == 2 {
            detailSegment.setTitle("監督", forSegmentAt: 0)
            detailSegment.setTitle("コーチ", forSegmentAt: 1)
            detailSegment.setTitle("マネ", forSegmentAt: 2)
            detailSegment.setTitle("庶務", forSegmentAt: 3)
            detailSegment.setTitle("分析", forSegmentAt: 4)
            
        }
        else if selectedIndex == 3 {
            detailSegment.setTitle("やる派", forSegmentAt: 0)
            detailSegment.setTitle("観る派", forSegmentAt: 1)
            detailSegment.setTitle("飲み派", forSegmentAt: 2)
            detailSegment.setTitle("熱狂的", forSegmentAt: 3)
            detailSegment.setTitle("にわか", forSegmentAt: 4)
        }
    }
    
    
    @IBAction func setButton(_ sender: Any) {
        if matchRequest.text == "" || interestedContents.text == "" || interestedContents.text == "(選択してください)" {
            SVProgressHUD.showError(withStatus: "「必須」項目を、\n全て埋めて下さい。")
        }
        else {
            let idCheck = userDefaults.string(forKey: "MatchID")
            
            if idCheck == "" {
            userDefaults.set("YES", forKey: "MatchSettingFlag")
            userDefaults.set("\(matchRequest.text!)", forKey: "MatchRequest")
            userDefaults.set("\(interestedContents.text!)", forKey: "MatchInterested")
            
            //選択されているセグメントのインデックス
            let selectedIndex = positionSegment.selectedSegmentIndex
            let selectedDetailIndex = detailSegment.selectedSegmentIndex
            userDefaults.set("\(selectedIndex)", forKey: "MatchPosition")
            userDefaults.set("\(selectedDetailIndex)", forKey: "MatchDetail")
            userDefaults.synchronize()
            
            // ImageViewから画像を取得する
            let imageData = userPhoto.image!.jpegData(compressionQuality: 0.5)
            let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
            // postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            let name = Auth.auth().currentUser?.displayName
            
            // **重要** 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const8.PostPath8).childByAutoId()
            let postDic = ["userID": Auth.auth().currentUser!.uid, "Request": matchRequest.text!, "Interested": interestedContents.text!, "Position": selectedIndex, "Detail": selectedDetailIndex, "userPhoto": imageString, "time": String(time), "name": name!] as [String : Any]
            //autoIDのID
            let autoid =  postRef.key
            print("\(autoid!)")
            postRef.setValue(postDic)
        
            userDefaults.set("\(autoid!)", forKey: "MatchID")
            userDefaults.synchronize()
            
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "初期設定が完了！")
        
            // 画面を閉じてViewControllerに戻る
            dismiss(animated: true, completion: nil)
            }
            else {
                userDefaults.set("YES", forKey: "MatchSettingFlag")
                userDefaults.set("\(matchRequest.text!)", forKey: "MatchRequest")
                userDefaults.set("\(interestedContents.text!)", forKey: "MatchInterested")
                
                //選択されているセグメントのインデックス
                let selectedIndex = positionSegment.selectedSegmentIndex
                let selectedDetailIndex = detailSegment.selectedSegmentIndex
                userDefaults.set("\(selectedIndex)", forKey: "MatchPosition")
                userDefaults.set("\(selectedDetailIndex)", forKey: "MatchDetail")
                userDefaults.synchronize()
                
                // ImageViewから画像を取得する
                let imageData = userPhoto.image!.jpegData(compressionQuality: 0.5)
                let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
                // postDataに必要な情報を取得しておく
                let time = Date.timeIntervalSinceReferenceDate
                let name = Auth.auth().currentUser?.displayName
                
                // **重要** 辞書を作成してFirebaseに保存する
                let postRef = Database.database().reference().child("Match").child("\(idCheck!)")
                let postDic = ["userID": Auth.auth().currentUser!.uid, "Request": matchRequest.text!, "Interested": interestedContents.text!, "Position": selectedIndex, "Detail": selectedDetailIndex, "userPhoto": imageString, "time": String(time), "name": name!] as [String : Any]
                postRef.updateChildValues(postDic)
                
                // HUDで投稿完了を表示する
                SVProgressHUD.showSuccess(withStatus: "初期設定が完了！")
                
                // 画面を閉じてViewControllerに戻る
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
