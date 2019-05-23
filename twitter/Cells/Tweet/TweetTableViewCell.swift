//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Рома Сумороков on 11/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var retweeted: UILabel!
    @IBOutlet weak var retweetedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var replyingTo: UILabel!
    @IBOutlet weak var replyingToHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockImageWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
        profilePhoto.imageView?.layer.cornerRadius = profilePhoto.frame.width / 2
        lockImage.invert()
        replyingToHeightConstraint.constant = 0
        retweetedHeightConstraint.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(tweet: HomeStatus) {
        tweetText.text = tweet.text
        
        profilePhoto.setImage(tweet.profileImage, for: .normal)
        likeButton.setTitle(tweet.likes != 0 ? "\(tweet.likes!)" : "", for: .normal)
        retweetButton.setTitle(tweet.retweets != 0 ? "\(tweet.retweets!)" : "", for: .normal) 
        nickname.text = tweet.name
        username.text = tweet.screenName
        
        if username.frame.width < 10 {
            username.text = ""
        }
        
        if tweet.isProtected! {
            lockImageWidthConstraint.constant = 24
        } else {
            lockImageWidthConstraint.constant = 0
        }
        if let user = tweet.retweetedUser {
            retweeted.text = "\(user) retweeted"
            retweetedHeightConstraint.constant = 15
        }
    }
}
