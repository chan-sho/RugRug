//
//  ChatTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/13.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit
import SVProgressHUD


class ChatTableCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var contents: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
        self.userPhoto.layer.borderColor = UIColor.gray.cgColor
        self.userPhoto.layer.borderWidth = 0.5
        
        //項目をクリツク可能に
        contents.isUserInteractionEnabled = true
        userName.isUserInteractionEnabled = true
        // ↓各Labelをタップする事でコピーができるようにする（ここから）
        let tgContents = UILongPressGestureRecognizer(target: self, action: #selector(ChatTableCell.tappedContents(_:)))
        contents.addGestureRecognizer(tgContents)
        let tgUserName = UILongPressGestureRecognizer(target: self, action: #selector(ChatTableCell.tappedUserName(_:)))
        userName.addGestureRecognizer(tgUserName)
        
        tgContents.cancelsTouchesInView = false
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
    @objc func tappedUserName(_ sender:UILongPressGestureRecognizer) {
        UIPasteboard.general.string = userName.text
        SVProgressHUD.showSuccess(withStatus: "テキストコピー完了：\n\n\(UIPasteboard.general.string!)")
        SVProgressHUD.dismiss(withDelay: 2.0)
    }
    
    
    func setPostData4(_ postData: PostData) {
        
        self.contents.text = "\(postData.contents ?? "")"
        self.userName.text = "\(postData.name!)"
        
        self.userPhoto.image = postData.userPhoto
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  h:mm a"
        let dateString = formatter.string(from: postData.date!)
        self.time.text = dateString
    }
    
}
