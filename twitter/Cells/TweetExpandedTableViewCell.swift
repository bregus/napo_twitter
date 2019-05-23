//
//  TweetExpandedTableViewCell.swift
//  twitter
//
//  Created by Рома Сумороков on 24/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class TweetExpandedTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewConstrint: NSLayoutConstraint!
    @IBOutlet weak var retweetedUser: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var profilePhoto: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
        profilePhoto.imageView?.layer.cornerRadius = profilePhoto.frame.width / 2
        lockImage.invert()
        lockImage.isHidden = true
        topViewConstrint.constant = 0
        topView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(tweet: HomeStatus) {
        tweetText.text = tweet.text
        
        profilePhoto.setImage(tweet.profileImage, for: .normal)
        nickname.text = tweet.name
        username.text = tweet.screenName
        
        if tweet.isProtected! {
            lockImage.isHidden = false
        }
        
        if let user = tweet.retweetedUser {
            topView.isHidden = false
            retweetedUser.text = "\(user) retweeted"
            topViewConstrint.constant = 20
            
        }
    }
    
}
