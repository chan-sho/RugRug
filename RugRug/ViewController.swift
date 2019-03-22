//
//  ViewController.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//
// 【UserDefaults管理】"InitialFlag"= Initial画面表示判定
// 【UserDefaults管理】"EULAagreement"= 利用規約に同意したかどうかの判定
// 【UserDefaults管理】"EULACheckFlag"= プライバシーポリシー・利用規約のページをきちんと開いた事を確認するFlag
// 【UserDefaults管理】"AccountDeleteFlag"= アカウント削除ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"RejectDataFlag"= 「リジェクト／管理」ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"CautionDataFlag"= 報告ボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"UserPhotoURLFlagof7x7"= 7x7でuserPhotoボタンを押した後の同意確認をするFlag
// 【UserDefaults管理】"MatchSettingFlag"= Match-Settingが完了しているかどうかの判別Flag


import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth


class ViewController: UIViewController {
    
    //user defaultsを使う準備
    let userDefaults:UserDefaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        
        //userDefaultsの初期値設定
        userDefaults.register(defaults: ["InitialFlag" : "NO", "EULAagreement" : "NO", "EULACheckFlag" : "NO", "AccountDeleteFlag" : "NO", "RejectDataFlag" : "NO",  "RejectUserFlag" : "NO", "CautionDataFlag" : "NO", "RejectIdArray" : [], "UserPhotoURLFlag" : "NO", "RejectUserArray" : [], "ChatRequestFlag" : "NO", "UserPhotoURLFlagof7x7" : "NO", "Reject7x7Array" : [], "Reject7x7UserArray" : [], "Chat7x7Flag" : "NO", "Reject7x7Flag" : "NO", "Caution7x7Flag" : "NO", "RejectUser7x7Flag" : "NO", "MatchSettingFlag" : "NO"])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let initialJudge = userDefaults.string(forKey: "InitialFlag")
        userDefaults.synchronize()
        
        // currentUserがnil(ログインしていない)場合
        if Auth.auth().currentUser == nil {
            
            if initialJudge == "YES" {
                // Login画面へ遷移
                let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(login!, animated: false, completion: nil)
            }
            else {
                // Initial画面へ遷移
                let initial = self.storyboard?.instantiateViewController(withIdentifier: "Initial")
                self.present(initial!, animated: false, completion: nil)
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupTab() {
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["Home", "matching", "PostType", "News", "Setting"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
        tabBarController.buttonsBackgroundColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 0.9)
        tabBarController.selectionIndicatorHeight = 0.0
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParent: self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let Home = storyboard?.instantiateViewController(withIdentifier: "Home")
        let Matching = storyboard?.instantiateViewController(withIdentifier: "Matching")
        let PostType = storyboard?.instantiateViewController(withIdentifier: "PostType")
        let News = storyboard?.instantiateViewController(withIdentifier: "News")
        let Setting = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(Home, at: 0)
        tabBarController.setView(Matching, at: 1)
        tabBarController.setView(PostType, at: 2)
        tabBarController.setView(News, at: 3)
        tabBarController.setView(Setting, at: 4)
    }
}

