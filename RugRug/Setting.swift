//
//  Setting.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/23.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD


class Setting: UIViewController {

    
    @IBOutlet weak var logOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()
        // Login画面へ遷移
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(login!, animated: true, completion: nil)
    }
    

}
