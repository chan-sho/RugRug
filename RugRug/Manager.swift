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

    @IBOutlet weak var news1Photo: UIImageView!
    @IBOutlet weak var adBigPhoto: UIImageView!
    @IBOutlet weak var adSmallPhoto: UIImageView!
    
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
        let imageData = news1Photo.image!.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        let imageAdBig = adBigPhoto.image!.jpegData(compressionQuality: 0.5)
        let imageStringAdBig = imageAdBig!.base64EncodedString(options: .lineLength64Characters)
        
        let imageAdSmall = adSmallPhoto.image!.jpegData(compressionQuality: 0.5)
        let imageStringAdSmall = imageAdSmall!.base64EncodedString(options: .lineLength64Characters)
        
        // **重要** 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const3.PostPath3)
        let postDic = ["News1Photo": imageString, "AdBigPhoto": imageStringAdBig,  "AdSmallPhoto": imageStringAdSmall] as [String : Any]
        postRef.childByAutoId().setValue(postDic)
    }
    
}
