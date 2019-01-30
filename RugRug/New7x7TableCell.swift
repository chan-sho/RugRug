//
//  New7x7TableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2019/01/30.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class New7x7TableCell: UITableViewCell {

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var userPhotoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
        self.userPhoto.layer.borderColor = UIColor.gray.cgColor
        self.userPhoto.layer.borderWidth = 0.5
        
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
        
    }
    
    
}
