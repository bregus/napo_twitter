//
//  User.swift
//  twitter
//
//  Created by Рома Сумороков on 15/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit
import Foundation
import STTwitter

class User {
    static var username: String = "@smodsd"
    static var name: String = "tt"
    static var profilePhoto: UIImage = #imageLiteral(resourceName: "C4rWY7Vtp7g.jpg")
    static var following: Int = 10
    static var followers: Int = 433
}

class TwitterClient {
    static let twitter = STTwitterAPI(oAuthConsumerKey: "k9w8uKaihmOIA40K6ED4qngFl", consumerSecret: "dB4T9qU9kjMlFVUS3o5IvtJCPVuPKzHtu1t9YUWLocltElm74I", oauthToken: "1004396015775076352-W61Y73WRCytpzrUHRt98yXt9MPrtRH", oauthTokenSecret: "BaYS15ZO6fNoIfHVhJdxErs93FDzU1Z7mda7uNh9la1MK")
}

struct HomeStatus {
    var text: String?
    var profileImage: UIImage?
    var name: String?
    var screenName: String?
    var likes: Int64?
    var retweets: Int64?
    var isProtected: Bool?
    var isVerified: Bool?
    var in_reply_to_screen_name: String?
}
