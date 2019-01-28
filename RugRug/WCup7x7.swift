//
//  WCup7x7.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/28.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class WCup7x7: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var newPostButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        // 他の画面から segue を使って戻ってきた時に呼ばれる
    }
    
}
