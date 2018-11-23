//
//  Login.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class Login: UIViewController, FBSDKLoginButtonDelegate {
    
    //facebookサインインボタンの生成準備
    let fbLoginBtn = FBSDKLoginButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //facebookサインインボタン
        fbLoginBtn.readPermissions = ["public_profile", "email"]
        fbLoginBtn.frame = CGRect(x: self.view.frame.size.width * 1/6, y: self.view.frame.size.height * 3/4, width: self.view.frame.size.width * 4/6, height: self.view.frame.size.width * 1/9)
        fbLoginBtn.delegate = self
        self.view.addSubview(fbLoginBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Facebookサインイン
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print("DEBUG_PRINT: " + error.localizedDescription)
            SVProgressHUD.showError(withStatus: "facebookサインインに失敗しました。")
            return
        }
        
        if result.isCancelled {
            SVProgressHUD.showError(withStatus: "facebookサインインをキャンセルしました。")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("DEBUG_PRINT: " + error.localizedDescription)
                SVProgressHUD.showError(withStatus: "facebookサインインに失敗しました。")
                return
            }
            // HUDを消す
            SVProgressHUD.dismiss()
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // ログアウトする
        try! Auth.auth().signOut()
    }

}
