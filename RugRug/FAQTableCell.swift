//
//  FAQTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2018/11/28.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit

class FAQTableCell: UITableViewCell {

    
    @IBOutlet weak var answerCategory: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var requestTextField: UILabel!
    @IBOutlet weak var answerTextField: UILabel!
    @IBOutlet weak var RugRugPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.RugRugPhoto.clipsToBounds = true
        self.RugRugPhoto.layer.cornerRadius = 20.0
        self.RugRugPhoto.layer.borderColor = UIColor.gray.cgColor
        self.RugRugPhoto.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setPostData2(_ postData: PostData) {
        
        self.answerCategory.text = "【\(postData.answerCategory ?? "")】"
        self.requestTextField.text = "\(postData.requestTextField ?? "")"
        self.answerTextField.text = "\(postData.answerTextField ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: postData.date!)
        self.time.text = dateString
    }
}
