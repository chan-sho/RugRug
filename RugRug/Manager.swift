//
//  Manager.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/29.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class Manager: UIViewController {

    @IBOutlet weak var adBigPhoto1: UIImageView!
    @IBOutlet weak var adBigPhoto2: UIImageView!
    @IBOutlet weak var adSmallPhoto1: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageAdBig1 = adBigPhoto1.image!.jpegData(compressionQuality: 0.5)
        let imageStringAdBig1 = imageAdBig1!.base64EncodedString(options: .lineLength64Characters)
        
        let imageAdBig2 = adBigPhoto2.image!.jpegData(compressionQuality: 0.5)
        let imageStringAdBig2 = imageAdBig2!.base64EncodedString(options: .lineLength64Characters)
        
        let imageAdSmall1 = adSmallPhoto1.image!.jpegData(compressionQuality: 0.5)
        let imageStringAdSmall1 = imageAdSmall1!.base64EncodedString(options: .lineLength64Characters)
        
        
        // **重要** 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const3.PostPath3)
        let postDic = ["BigPhoto1": imageStringAdBig1, "BigPhoto2": imageStringAdBig2,  "SmallPhoto1": imageStringAdSmall1] as [String : Any]
        postRef.childByAutoId().setValue(postDic)
    }
    
}
