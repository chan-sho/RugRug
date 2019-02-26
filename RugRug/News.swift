//
//  News.swift
//  RugRug
//
//  Created by 高野翔 on 2019/02/25.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class News: UIViewController {
    
    @IBOutlet weak var sevenButton_1: UIButton!
    @IBOutlet weak var sevenButton_2: UIButton!
    @IBOutlet weak var sevenButton_3: UIButton!
    
    @IBOutlet weak var comingSoon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comingSoon.clipsToBounds = true
        comingSoon.layer.cornerRadius = 75.0

        //ボタン同時押しによるアプリクラッシュを防ぐ
        sevenButton_1.isExclusiveTouch = true
        sevenButton_2.isExclusiveTouch = true
        sevenButton_3.isExclusiveTouch = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
