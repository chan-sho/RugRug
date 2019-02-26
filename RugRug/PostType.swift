//
//  PostType.swift
//  RugRug
//
//  Created by 高野翔 on 2019/02/25.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class PostType: UIViewController {

    @IBOutlet weak var postType1: UIButton!
    @IBOutlet weak var postType2: UIButton!
    @IBOutlet weak var postType3: UIButton!
    @IBOutlet weak var postType4: UIButton!
    @IBOutlet weak var postType5: UIButton!
    @IBOutlet weak var postType1_2: UIButton!
    @IBOutlet weak var postType2_2: UIButton!
    @IBOutlet weak var postType3_2: UIButton!
    @IBOutlet weak var postType4_2: UIButton!
    @IBOutlet weak var postType5_2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postType1.clipsToBounds = true
        postType1.layer.cornerRadius = 15.0
        postType2.clipsToBounds = true
        postType2.layer.cornerRadius = 15.0
        postType3.clipsToBounds = true
        postType3.layer.cornerRadius = 15.0
        postType4.clipsToBounds = true
        postType4.layer.cornerRadius = 15.0
        postType5.clipsToBounds = true
        postType5.layer.cornerRadius = 15.0
    }
    

    @IBAction func postType1(_ sender: Any) {
    }
    @IBAction func postType1_2(_ sender: Any) {
    }
    
    
    @IBAction func postType2(_ sender: Any) {
    }
    @IBAction func postType2_2(_ sender: Any) {
    }
    
    
    @IBAction func postType3(_ sender: Any) {
    }
    @IBAction func postType3_2(_ sender: Any) {
    }
    
    
    @IBAction func postType4(_ sender: Any) {
    }
    @IBAction func postType4_2(_ sender: Any) {
    }
    
    
    @IBAction func postType5(_ sender: Any) {
    }
    @IBAction func postType5_2(_ sender: Any) {
    }
    
    
}
