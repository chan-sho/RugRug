//
//  MatchDoneTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2019/03/24.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class MatchDoneTableCell: UITableViewCell {
    
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var userPhotoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 35.0
        self.userPhoto.layer.borderColor = UIColor.white.cgColor
        self.userPhoto.layer.borderWidth = 1.0
        
        // 枠のカラー
        category.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0).cgColor
        position.layer.borderColor = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1.0).cgColor
        // 枠の幅
        category.layer.borderWidth = 0.5
        position.layer.borderWidth = 0.5
        // 枠を角丸にする場合
        category.layer.cornerRadius = 10.0
        category.layer.masksToBounds = true
        position.layer.cornerRadius = 10.0
        position.layer.masksToBounds = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setPostData7(_ postData: PostData) {
        
        self.userName.text = "\(postData.name!)"
        self.userPhoto.image = postData.userPhoto
        self.contents.text = "\(postData.Request!)"
        self.category.text = "   \(postData.Interested!)   "
        
        let positionCheck = postData.Position
        let detailCheck = postData.Detail
        
        if positionCheck == 0 {
            if detailCheck == 0 {
                self.position.text = "   FW / PR   "
            }
            else if detailCheck == 1 {
                self.position.text = "   FW / HO   "
            }
            else if detailCheck == 2 {
                self.position.text = "   FW / LO   "
            }
            else if detailCheck == 3 {
                self.position.text = "   FW / FL   "
            }
            else if detailCheck == 4 {
                self.position.text = "   FW / 8   "
            }
        }
        else if positionCheck == 1 {
            if detailCheck == 0 {
                self.position.text = "   BK / SH   "
            }
            else if detailCheck == 1 {
                self.position.text = "   BK / SO   "
            }
            else if detailCheck == 2 {
                self.position.text = "   BK / CTB   "
            }
            else if detailCheck == 3 {
                self.position.text = "   BK / WTB   "
            }
            else if detailCheck == 4 {
                self.position.text = "   BK / FB   "
            }
        }
        else if positionCheck == 2 {
            if detailCheck == 0 {
                self.position.text = "   運営 / 監督   "
            }
            else if detailCheck == 1 {
                self.position.text = "   運営 / コーチ   "
            }
            else if detailCheck == 2 {
                self.position.text = "   運営 / マネ   "
            }
            else if detailCheck == 3 {
                self.position.text = "   運営 / 庶務   "
            }
            else if detailCheck == 4 {
                self.position.text = "   運営 / 分析   "
            }
        }
        else if positionCheck == 3 {
            if detailCheck == 0 {
                self.position.text = "   ファン / やる派   "
            }
            else if detailCheck == 1 {
                self.position.text = "   ファン / 観る派   "
            }
            else if detailCheck == 2 {
                self.position.text = "   ファン / 飲み派   "
            }
            else if detailCheck == 3 {
                self.position.text = "   ファン / 熱狂的   "
            }
            else if detailCheck == 4 {
                self.position.text = "   ファン / にわか   "
            }
        }
    }
    
}
