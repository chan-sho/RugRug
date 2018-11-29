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
        let imageData = UIImageJPEGRepresentation(news1Photo.image!, 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        print("\(imageString)")
        
        // **重要** 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const3.PostPath3)
        let postDic = ["News1Photo": imageString] as [String : Any]
        postRef.childByAutoId().setValue(postDic)
    }
    
}
