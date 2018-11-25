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
    @IBOutlet weak var reviseButton: UIButton!
    @IBOutlet weak var userPhotoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
        
        //項目をクリツク可能に
        contents.isUserInteractionEnabled = true
        name.isUserInteractionEnabled = true
        // ↓各Labelをタップする事でコピーができるようにする（ここから）
        let tgContents = UILongPressGestureRecognizer(target: self, action: #selector(PostTableCell.tappedContents(_:)))
        contents.addGestureRecognizer(tgContents)
        let tgName = UILongPressGestureRecognizer(target: self, action: #selector(PostTableCell.tappedName(_:)))
        name.addGestureRecognizer(tgName)
        
        tgContents.cancelsTouchesInView = false
        tgName.cancelsTouchesInView = false
        
        //ボタン同時押しによるアプリクラッシュを防ぐ
        likeButton.isExclusiveTouch = true
        reviseButton.isExclusiveTouch = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    // ↓各Labelをタップする事でコピーができるようにする（ここから）
    @objc func tappedContents(_ sender:UILongPressGestureRecognizer) {
        UIPasteboard.general.string = contents.text
        SVProgressHUD.showSuccess(withStatus: "テキストコピー完了：\n\n\(UIPasteboard.general.string!)")
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
    @objc func tappedName(_ sender:UILongPressGestureRecognizer) {
        UIPasteboard.general.string = name.text
        SVProgressHUD.showSuccess(withStatus: "テキストコピー完了：\n\n\(UIPasteboard.general.string!)")
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
    // ↑各Labelをタップする事でコピーができるようにする（ここまで）
    
    
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
        
    }
    
}
