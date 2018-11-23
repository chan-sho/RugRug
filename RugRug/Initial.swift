//
//  Initial.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"InitialFlag"= Initial画面表示判定

import UIKit

class Initial: UIViewController {
    
    
    @IBOutlet weak var initialBackGround: UIImageView!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func goToLoginButton(_ sender: Any) {
        //利用規約＆プライバシーポリシー画面へ
        
        
        //Login画面へ
        userDefaults.set("YES", forKey: "InitialFlag")
        userDefaults.synchronize()
        // 画面を閉じてViewControllerに戻る
        self.dismiss(animated: false, completion: nil)
    }
    

}
