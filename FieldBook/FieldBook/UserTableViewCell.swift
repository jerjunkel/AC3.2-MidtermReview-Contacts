//
//  UserTableViewCell.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    var user: User!{
        didSet{
            setupCell()
        }
    }
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(){
        self.userName.text = user.name
        self.userEmail.text = user.email
        self.userPhoto.layer.cornerRadius = userPhoto.frame.width / 2
        self.userPhoto.layer.masksToBounds = true
        
        ApiRequestManager.manager.getImage(from: user.photo) { (image) in
            DispatchQueue.main.async {
                self.userPhoto.image = image
            }
        }
    }

}
