//
//  UserTableViewCell.swift
//  twitter
//
//  Created by Рома Сумороков on 17/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var decs: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBAction func followButtonTapped(_ sender: Any) {
        if followButton.title(for: .normal) == "Follow" {
            Requests.followUser(screenName: screenName.text!, userID: nickname.text!) { () in
                self.followButton.backgroundColor = UIColor(cgColor: self.followButton.layer.borderColor!)
                self.followButton.setTitle("Following", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                
            }
        } else {
            Requests.unFollowUser(screenName: screenName.text!, userID: nickname.text!) { () in
                self.followButton.backgroundColor = .white
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(UIColor(cgColor: self.followButton.layer.borderColor!), for: .normal)
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.cornerRadius = followButton.frame.height / 2
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = followButton.backgroundColor?.cgColor
        
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.imageView?.layer.cornerRadius = profileButton.frame.width / 2
        profileButton.setImage(User.current.profilePhoto, for: .normal)
        decs.text = ""
        lockImage.invert()
        lockImage.isHidden = true
    }
    
    func setup(user: User) {
        decs.text = user.description != "" ? user.description : " "
        
        profileButton.setImage(user.profilePhoto, for: .normal)
        nickname.text = user.name
        screenName.text = user.username
        
        if !user.isFollowing {
            followButton.backgroundColor = .white
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(UIColor(cgColor: followButton.layer.borderColor!), for: .normal)
        }
        
        if user.isProtected {
            lockImage.isHidden = false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
