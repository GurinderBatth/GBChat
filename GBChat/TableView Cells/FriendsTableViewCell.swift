//
//  FriendsTableViewCell.swift
//  GBChat
//
//  Created by Apple on 25/12/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewFriend:UIImageView!
    
    @IBOutlet weak var labelName:UILabel!
    
    var details: FriendsModel!{
        didSet{
            self.labelName.text = details.name
            let storageRef = Storage.storage().reference()
            let starsRef = storageRef.child("UserImages/\(details.email!)/\(details.email!).jpg")
            starsRef.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    self.imageViewFriend.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
}
