//
//  InfoTableCell.swift
//  RugRug
//
//  Created by 高野翔 on 2018/12/10.
//  Copyright © 2018 高野翔. All rights reserved.
//

import UIKit

class InfoTableCell: UITableViewCell {
    
    
    @IBOutlet weak var askUserPhoto: UIImageView!
    @IBOutlet weak var askUserName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkedPostButton: UIButton!
    @IBOutlet weak var askUserPhotoButton: UIButton!
    @IBOutlet weak var chatRequestLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.askUserPhoto.clipsToBounds = true
        self.askUserPhoto.layer.cornerRadius = 35.0
        self.askUserPhoto.layer.borderColor = UIColor.gray.cgColor
        self.askUserPhoto.layer.borderWidth = 0.5
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setPostData3(_ postData: PostData) {
        
        let askUserPhotoURL = "\(postData.AskUserURL ?? "")"
        
        if askUserPhotoURL != "" {
            let url = URL(string: "\(askUserPhotoURL)")
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.askUserPhoto.image = UIImage(data: data!)
                }
            }).resume()
        }
        
        self.askUserName.text = "\(postData.AskUserName ?? "")"
        
        self.chatRequestLabel.text = "\(postData.ChatRequest ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: postData.date!)
        self.time.text = dateString
    }
    
}
