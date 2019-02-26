//
//  Revise7x7.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/30.
//  Copyright © 2019 高野翔. All rights reserved.
//
// 【UserDefaults管理】"revise7x7Id"= 投稿画面で「編集」を押した7x7のID


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


class Revise7x7: UIViewController, UITextFieldDelegate {
    
    
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

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var reviseData : String?
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
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
        
        editButton.layer.cornerRadius = 30.0
        deleteButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        editButton.isExclusiveTouch = true
        deleteButton.isExclusiveTouch = true
    }
    
    
    //念のため（※userDefaultsの更新タイミングが遅かった場合のために）
    override func viewWillAppear(_ animated: Bool) {
        reviseData = userDefaults.string(forKey: "revise7x7Id")
        print("reviseData = \(reviseData!)")
        
        if reviseData == "" {
            SVProgressHUD.showError(withStatus: "エラーが発生しました！。\nお手数ですが、再度最初から手続きをお願いします。\n\nError! Please check")
            return
        }
            //reviseDataに対象の投稿ナンバーが入っている場合
        else {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("7x7").child("\(self.reviseData!)").child("userID")
            
            //  FirebaseからobserveSingleEventで1回だけデータ検索
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String
                
                let uid = Auth.auth().currentUser?.uid
                if uid == value {
                    //Firebaseから該当データを抽出
                    let refToRevise = Database.database().reference().child("7x7").child("\(self.reviseData!)")
                    
                    refToRevise.observeSingleEvent(of: .value, with: { (snapshot) in
                        var valueToRevise = snapshot.value as! [String: AnyObject]
                        //各Textに保存
                        let revise7x7 :[String] = (valueToRevise["7×7"] as? [String])!
                        self.T0.text = "\(revise7x7[0])"
                        self.T1.text = "\(revise7x7[1])"
                        self.T2.text = "\(revise7x7[2])"
                        self.T3.text = "\(revise7x7[3])"
                        self.T4.text = "\(revise7x7[4])"
                        self.T5.text = "\(revise7x7[5])"
                        self.T6.text = "\(revise7x7[6])"
                        self.T7.text = "\(revise7x7[7])"
                        self.T8.text = "\(revise7x7[8])"
                        self.T9.text = "\(revise7x7[9])"
                        self.T10.text = "\(revise7x7[10])"
                        self.T11.text = "\(revise7x7[11])"
                        self.T12.text = "\(revise7x7[12])"
                        self.T13.text = "\(revise7x7[13])"
                        self.T14.text = "\(revise7x7[14])"
                        self.T15.text = "\(revise7x7[15])"
                        self.T16.text = "\(revise7x7[16])"
                        self.T17.text = "\(revise7x7[17])"
                        self.T18.text = "\(revise7x7[18])"
                        self.T19.text = "\(revise7x7[19])"
                        self.T20.text = "\(revise7x7[20])"
                        self.T21.text = "\(revise7x7[21])"
                        self.T22.text = "\(revise7x7[22])"
                        self.T23.text = "\(revise7x7[23])"
                        self.T24.text = "\(revise7x7[24])"
                        self.T25.text = "\(revise7x7[25])"
                        self.T26.text = "\(revise7x7[26])"
                        self.T27.text = "\(revise7x7[27])"
                        self.T28.text = "\(revise7x7[28])"
                        self.T29.text = "\(revise7x7[29])"
                        self.T30.text = "\(revise7x7[30])"
                        self.T31.text = "\(revise7x7[31])"
                        self.T32.text = "\(revise7x7[32])"
                        self.T33.text = "\(revise7x7[33])"
                        self.T34.text = "\(revise7x7[34])"
                        self.T35.text = "\(revise7x7[35])"
                        self.T36.text = "\(revise7x7[36])"
                        self.T37.text = "\(revise7x7[37])"
                        self.T38.text = "\(revise7x7[38])"
                        self.T39.text = "\(revise7x7[39])"
                        self.T40.text = "\(revise7x7[40])"
                        self.T41.text = "\(revise7x7[41])"
                        self.T42.text = "\(revise7x7[42])"
                        self.T43.text = "\(revise7x7[43])"
                        self.T44.text = "\(revise7x7[44])"
                        self.T45.text = "\(revise7x7[45])"
                        self.T46.text = "\(revise7x7[46])"
                        self.T47.text = "\(revise7x7[47])"
                        self.T48.text = "\(revise7x7[48])"
                    })
                }
                else {
                    SVProgressHUD.showError(withStatus: "エラーが発生しました！\nお手数ですが、再度最初から手続きをお願いします。\n\nError! Please check")
                    return
                }
                
            }) { (error) in
                print(error.localizedDescription)
                SVProgressHUD.showError(withStatus: "エラーが発生しました！\nお手数ですが、再度最初から手続きをお願いします。\n\nError! Please check")
                return
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
    

    @IBAction func editButton(_ sender: Any) {
        //念の為もう一回userDefaultsから取得しておく
        reviseData = userDefaults.string(forKey: "revise7x7Id")
        
        let revised7x7 = ["\(T0.text ?? "")","\(T1.text ?? "")","\(T2.text ?? "")","\(T3.text ?? "")","\(T4.text ?? "")","\(T5.text ?? "")","\(T6.text ?? "")","\(T7.text ?? "")","\(T8.text ?? "")","\(T9.text ?? "")","\(T10.text ?? "")","\(T11.text ?? "")","\(T12.text ?? "")","\(T13.text ?? "")","\(T14.text ?? "")","\(T15.text ?? "")","\(T16.text ?? "")","\(T17.text ?? "")","\(T18.text ?? "")","\(T19.text ?? "")","\(T20.text ?? "")","\(T21.text ?? "")","\(T22.text ?? "")","\(T23.text ?? "")","\(T24.text ?? "")","\(T25.text ?? "")","\(T26.text ?? "")","\(T27.text ?? "")","\(T28.text ?? "")","\(T29.text ?? "")","\(T30.text ?? "")","\(T31.text ?? "")","\(T32.text ?? "")","\(T33.text ?? "")","\(T34.text ?? "")","\(T35.text ?? "")","\(T36.text ?? "")","\(T37.text ?? "")","\(T38.text ?? "")","\(T39.text ?? "")","\(T40.text ?? "")","\(T41.text ?? "")","\(T42.text ?? "")","\(T43.text ?? "")","\(T44.text ?? "")","\(T45.text ?? "")","\(T46.text ?? "")","\(T47.text ?? "")","\(T48.text ?? "")"]
        
        let Data = ["7×7": revised7x7]
            
        //Firebaseから該当データを選択し、データの各項目をアップデート
        let refToReviseData = Database.database().reference().child("7x7").child("\(reviseData!)")
        refToReviseData.updateChildValues(Data)
        
        // 画面を閉じてViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        //念の為もう一回userDefaultsから取得しておく
        reviseData = userDefaults.string(forKey: "revise7x7Id")
        //Firebaseからデータを削除
        let refOfDelete = Database.database().reference().child("7x7").child("\(self.reviseData!)")
        refOfDelete.removeValue()
        
        SVProgressHUD.showSuccess(withStatus: "対象の投稿が削除されました。\nDelete Completed")
        
        // 画面を閉じてViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }
    
}
