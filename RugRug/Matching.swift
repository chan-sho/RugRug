//
//  Matching.swift
//  RugRug
//
//  Created by 高野翔 on 2019/03/19.
//  Copyright © 2019 高野翔. All rights reserved.
//
// 【UserDefaults管理】"MatchSettingFlag"= Match-Settingが完了しているかどうかの判別Flag
// 【UserDefaults管理】"MatchPosition"= Match-Settingで設定したポジション
// 【UserDefaults管理】"MatchDetail"= Match-Settingで設定したポジションの詳細


import UIKit
import SVProgressHUD


class Matching: UIViewController {
    
    
    @IBOutlet weak var initialSettingButton: UIButton!
    @IBOutlet weak var swipeButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSettingButton.layer.cornerRadius = 30.0
        swipeButton.layer.cornerRadius = 30.0
        contactButton.layer.cornerRadius = 30.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        initialSettingButton.isExclusiveTouch = true
        swipeButton.isExclusiveTouch = true
        contactButton.isExclusiveTouch = true
        
        //userDefaultsの初期値設定
        userDefaults.register(defaults: ["MatchSettingFlag" : "NO", "MatchPosition" : 0, "MatchDetail" : 0])
    }
    
    
    @IBAction func swipeButton(_ sender: Any) {
        let matchSettingFlag = userDefaults.string(forKey: "MatchSettingFlag")
        if matchSettingFlag == "NO" {
            SVProgressHUD.showError(withStatus: "まずは「初期設定」を\n完了して下さい。")
        }
        if matchSettingFlag == "YES" {
            performSegue(withIdentifier: "toMatchSwipe", sender: nil)
        }
    }
    
    
    @IBAction func contactButton(_ sender: Any) {
        let matchSettingFlag = userDefaults.string(forKey: "MatchSettingFlag")
        if matchSettingFlag == "NO" {
            SVProgressHUD.showError(withStatus: "まずは「初期設定」を\n完了して下さい。")
        }
        if matchSettingFlag == "YES" {
            performSegue(withIdentifier: "toMatchContact", sender: nil)
        }
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }

    
}
