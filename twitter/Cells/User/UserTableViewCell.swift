//
//  UserTableViewCell.swift
//  twitter
//
//  Created by Рома Сумороков on 17/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var descHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var decs: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.cornerRadius = 10.0
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.imageView?.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.setImage(User.current.profilePhoto, for: .normal)
        decs.text = ""
        lockImage.invert()
        lockImage.isHidden = true
    }
    
    func setup(user: User) {
        decs.text = user.description
        
        profileButton.setImage(user.profilePhoto, for: .normal)
        nickname.text = user.name
        name.text = user.username
        
        if user.isProtected {
            lockImage.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
