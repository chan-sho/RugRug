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
        fbLoginBtn.frame = CGRect(x: self.view.frame.size.width * 1/8, y: self.view.frame.size.height * 1/2, width: self.view.frame.size.width * 6/8, height: self.view.frame.size.width * 1/8)
        fbLoginBtn.delegate = self
        self.view.addSubview(fbLoginBtn)
        
        //背景の設定
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "Login(ver1.0)")
        bg.contentMode = UIView.ContentMode.scaleAspectFill
        bg.clipsToBounds = true
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Facebookサインイン
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print("DEBUG_PRINT: " + error.localizedDescription)
            SVProgressHUD.showError(withStatus: "facebookサインインに\n失敗しました。")
            return
        }
        
        if result.isCancelled {
            SVProgressHUD.showError(withStatus: "facebookサインインを\nキャンセルしました。")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("DEBUG_PRINT: " + error.localizedDescription)
                SVProgressHUD.showError(withStatus: "facebookサインインに\n失敗しました。")
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
