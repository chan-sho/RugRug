//
//  Reject.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/07.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD


class Reject: UIViewController {
    
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var rejectData : String?
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        rejectButton.isExclusiveTouch = true
        reportButton.isExclusiveTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    @IBAction func rejectButton(_ sender: Any) {
        rejectData = userDefaults.string(forKey: "rejectDataId")
        print("rejectData = \(rejectData!)")
        
        let uid = Auth.auth().currentUser?.uid
        let postRef = Database.database().reference().child(Const.PostPath).child(rejectData!).child("rejects")
        let rejects = ["rejects": uid]
        postRef.updateChildValues(rejects)
    }
    
    
    @IBAction func reportButton(_ sender: Any) {
        rejectData = userDefaults.string(forKey: "rejectDataId")
        print("rejectData = \(rejectData!)")
        
        let uid = Auth.auth().currentUser?.uid
    }
    
}
