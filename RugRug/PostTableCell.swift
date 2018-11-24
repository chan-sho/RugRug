//
//  PostTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/24.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostTableCell: UITableViewCell {

    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mySecretButton: UIButton!
    @IBOutlet weak var reviseButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func setPostData(_ postData: PostData) {
        
        self.category.text = "【\(postData.category!)】"
        self.contents.text = "\(postData.contents ?? "")"
        self.name.text = "\(postData.name!)"
        
        self.userPhoto.image = postData.userPhoto
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
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
        
        if postData.mySecretSelected {
            let buttonImage = UIImage(named:"mySecret_yes")
            self.mySecretButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named:"mySecret_no")
            self.mySecretButton.setImage(buttonImage, for: .normal)
        }
        
    }
    
}
