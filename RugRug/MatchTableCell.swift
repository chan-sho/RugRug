//
//  MatchTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2019/03/23.
//  Copyright © 2019 高野翔. All rights reserved.
//

import UIKit

class MatchTableCell: UITableViewCell {
    
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var request: UILabel!
    @IBOutlet weak var interested: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var positionDetail: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhoto.clipsToBounds = true
        self.userPhoto.layer.cornerRadius = 50.0
        self.userPhoto.layer.borderColor = UIColor.white.cgColor
        self.userPhoto.layer.borderWidth = 1.0
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func setPostData6(_ postData: PostData) {
        
        self.userName.text = "\(postData.name!)"
        self.userPhoto.image = postData.userPhoto
        self.request.text = "\(postData.Request!)"
        self.interested.text = "\(postData.Interested!)"
        
        let positionCheck = postData.Position
        let detailCheck = postData.Detail
        
        if positionCheck == 0 {
            self.position.text = "FW"
            if detailCheck == 0 {
                self.positionDetail.text = "PR"
            }
            else if detailCheck == 1 {
                self.positionDetail.text = "HO"
            }
            else if detailCheck == 2 {
                self.positionDetail.text = "LO"
            }
            else if detailCheck == 3 {
                self.positionDetail.text = "FL"
            }
            else if detailCheck == 4 {
                self.positionDetail.text = "8"
            }
        }
        else if positionCheck == 1 {
            self.position.text = "BK"
            if detailCheck == 0 {
                self.positionDetail.text = "SH"
            }
            else if detailCheck == 1 {
                self.positionDetail.text = "SO"
            }
            else if detailCheck == 2 {
                self.positionDetail.text = "CTB"
            }
            else if detailCheck == 3 {
                self.positionDetail.text = "WTB"
            }
            else if detailCheck == 4 {
                self.positionDetail.text = "FB"
            }
        }
        else if positionCheck == 2 {
            self.position.text = "運営(Op.)"
            if detailCheck == 0 {
                self.positionDetail.text = "監督(Director)"
            }
            else if detailCheck == 1 {
                self.positionDetail.text = "コーチ(Coach)"
            }
            else if detailCheck == 2 {
                self.positionDetail.text = "マネ(Assistant)"
            }
            else if detailCheck == 3 {
                self.positionDetail.text = "庶務(Back Office)"
            }
            else if detailCheck == 4 {
                self.positionDetail.text = "分析(Analyst)"
            }
        }
        else if positionCheck == 3 {
            self.position.text = "Fan"
            if detailCheck == 0 {
                self.positionDetail.text = "やる派(Player)"
            }
            else if detailCheck == 1 {
                self.positionDetail.text = "観る派(Watch)"
            }
            else if detailCheck == 2 {
                self.positionDetail.text = "飲み派(Drink)"
            }
            else if detailCheck == 3 {
                self.positionDetail.text = "熱狂的(Enthusiastic)"
            }
            else if detailCheck == 4 {
                self.positionDetail.text = "にわか(Bandwagon)"
            }
        }
    }
    
    
}
