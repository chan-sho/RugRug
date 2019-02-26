//
//  New7x7TableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/30.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class New7x7TableCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userPhotoButton: UIButton!
    
    @IBOutlet weak var T0: UITextField!
    @IBOutlet weak var T1: UITextField!
    @IBOutlet weak var T2: UITextField!
    @IBOutlet weak var T3: UITextField!
    @IBOutlet weak var T4: UITextField!
    @IBOutlet weak var T5: UITextField!
    @IBOutlet weak var T6: UITextField!
    @IBOutlet weak var T7: UITextField!
    @IBOutlet weak var T8: UITextField!
    @IBOutlet weak var T9: UITextField!
    @IBOutlet weak var T10: UITextField!
    @IBOutlet weak var T11: UITextField!
    @IBOutlet weak var T12: UITextField!
    @IBOutlet weak var T13: UITextField!
    @IBOutlet weak var T14: UITextField!
    @IBOutlet weak var T15: UITextField!
    @IBOutlet weak var T16: UITextField!
    @IBOutlet weak var T17: UITextField!
    @IBOutlet weak var T18: UITextField!
    @IBOutlet weak var T19: UITextField!
    @IBOutlet weak var T20: UITextField!
    @IBOutlet weak var T21: UITextField!
    @IBOutlet weak var T22: UITextField!
    @IBOutlet weak var T23: UITextField!
    @IBOutlet weak var T24: UITextField!
    @IBOutlet weak var T25: UITextField!
    @IBOutlet weak var T26: UITextField!
    @IBOutlet weak var T27: UITextField!
    @IBOutlet weak var T28: UITextField!
    @IBOutlet weak var T29: UITextField!
    @IBOutlet weak var T30: UITextField!
    @IBOutlet weak var T31: UITextField!
    @IBOutlet weak var T32: UITextField!
    @IBOutlet weak var T33: UITextField!
    @IBOutlet weak var T34: UITextField!
    @IBOutlet weak var T35: UITextField!
    @IBOutlet weak var T36: UITextField!
    @IBOutlet weak var T37: UITextField!
    @IBOutlet weak var T38: UITextField!
    @IBOutlet weak var T39: UITextField!
    @IBOutlet weak var T40: UITextField!
    @IBOutlet weak var T41: UITextField!
    @IBOutlet weak var T42: UITextField!
    @IBOutlet weak var T43: UITextField!
    @IBOutlet weak var T44: UITextField!
    @IBOutlet weak var T45: UITextField!
    @IBOutlet weak var T46: UITextField!
    @IBOutlet weak var T47: UITextField!
    @IBOutlet weak var T48: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
        self.userPhoto.layer.borderColor = UIColor.white.cgColor
        self.userPhoto.layer.borderWidth = 1.0
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        likeButton.isExclusiveTouch = true
        editButton.isExclusiveTouch = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setPostData5(_ postData: PostData) {
        
        self.name.text = "\(postData.name!)"
        
        self.userPhoto.image = postData.userPhoto
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  h:mm a"
        let dateString = formatter.string(from: postData.date!)
        self.date.text = dateString
        
        let likeNumber = postData.likes.count
        like.text = "\(likeNumber)"
        
        if postData.isLiked {
            let buttonImage = UIImage(named:"like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named:"like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        self.T0.text = "\(postData.new7x7?[0] ?? "")"
        self.T1.text = "\(postData.new7x7?[1] ?? "")"
        self.T2.text = "\(postData.new7x7?[2] ?? "")"
        self.T3.text = "\(postData.new7x7?[3] ?? "")"
        self.T4.text = "\(postData.new7x7?[4] ?? "")"
        self.T5.text = "\(postData.new7x7?[5] ?? "")"
        self.T6.text = "\(postData.new7x7?[6] ?? "")"
        self.T7.text = "\(postData.new7x7?[7] ?? "")"
        self.T8.text = "\(postData.new7x7?[8] ?? "")"
        self.T9.text = "\(postData.new7x7?[9] ?? "")"
        self.T10.text = "\(postData.new7x7?[10] ?? "")"
        self.T11.text = "\(postData.new7x7?[11] ?? "")"
        self.T12.text = "\(postData.new7x7?[12] ?? "")"
        self.T13.text = "\(postData.new7x7?[13] ?? "")"
        self.T14.text = "\(postData.new7x7?[14] ?? "")"
        self.T15.text = "\(postData.new7x7?[15] ?? "")"
        self.T16.text = "\(postData.new7x7?[16] ?? "")"
        self.T17.text = "\(postData.new7x7?[17] ?? "")"
        self.T18.text = "\(postData.new7x7?[18] ?? "")"
        self.T19.text = "\(postData.new7x7?[19] ?? "")"
        self.T20.text = "\(postData.new7x7?[20] ?? "")"
        self.T21.text = "\(postData.new7x7?[21] ?? "")"
        self.T22.text = "\(postData.new7x7?[22] ?? "")"
        self.T23.text = "\(postData.new7x7?[23] ?? "")"
        self.T24.text = "\(postData.new7x7?[24] ?? "")"
        self.T25.text = "\(postData.new7x7?[25] ?? "")"
        self.T26.text = "\(postData.new7x7?[26] ?? "")"
        self.T27.text = "\(postData.new7x7?[27] ?? "")"
        self.T28.text = "\(postData.new7x7?[28] ?? "")"
        self.T29.text = "\(postData.new7x7?[29] ?? "")"
        self.T30.text = "\(postData.new7x7?[30] ?? "")"
        self.T31.text = "\(postData.new7x7?[31] ?? "")"
        self.T32.text = "\(postData.new7x7?[32] ?? "")"
        self.T33.text = "\(postData.new7x7?[33] ?? "")"
        self.T34.text = "\(postData.new7x7?[34] ?? "")"
        self.T35.text = "\(postData.new7x7?[35] ?? "")"
        self.T36.text = "\(postData.new7x7?[36] ?? "")"
        self.T37.text = "\(postData.new7x7?[37] ?? "")"
        self.T38.text = "\(postData.new7x7?[38] ?? "")"
        self.T39.text = "\(postData.new7x7?[39] ?? "")"
        self.T40.text = "\(postData.new7x7?[40] ?? "")"
        self.T41.text = "\(postData.new7x7?[41] ?? "")"
        self.T42.text = "\(postData.new7x7?[42] ?? "")"
        self.T43.text = "\(postData.new7x7?[43] ?? "")"
        self.T44.text = "\(postData.new7x7?[44] ?? "")"
        self.T45.text = "\(postData.new7x7?[45] ?? "")"
        self.T46.text = "\(postData.new7x7?[46] ?? "")"
        self.T47.text = "\(postData.new7x7?[47] ?? "")"
        self.T48.text = "\(postData.new7x7?[48] ?? "")"
        
    }
    
    
}
