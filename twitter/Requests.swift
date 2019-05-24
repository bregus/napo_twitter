//
//  Requests.swift
//  twitter
//
//  Created by Рома Сумороков on 23/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class Requests {
    static func getCurrentUserInfo() {
        TwitterClient.twitter?.getUserInformation(for: "mEeLAmQbdmlqejh", successBlock: { (info) in
            User.current.username = "@\(info?["screen_name"] ?? "")"
            User.current.name = info?["name"] as! String
            User.current.followers = info?["followers_count"] as! Int
            User.current.following = info?["friends_count"] as! Int
            User.current.isProtected = info?["protected"] as! Bool
            User.current.isVerified = info?["verified"] as! Bool
            
            let profileImageUrl = info?["profile_image_url_https"] as? String
            let url = URL(string: profileImageUrl!.replacingOccurrences(of: "_normal", with: ""))!
            let profileImage = UIImageView()
            profileImage.af_setImage(withURL: url, completion: { (image) in
                User.current.profilePhoto = profileImage.image!
                NotificationCenter.default.post(name: Notification.Name("didReceiveData"), object: nil)
            })
        }, errorBlock: { (error) in
            
        })
    }
    
    static func getFollowing(completion: ((_ IDs: [User]) -> Void)?) {
        //        TwitterClient.twitter?.getFollowersForScreenName("mEeLAmQbdmlqejh", successBlock: { (info) in
        //            print(info)
        //        }, errorBlock: { (error) in
        //
        //        })
                TwitterClient.twitter?.getFriendsForScreenName("mEeLAmQbdmlqejh", successBlock: { (info) in
                    var following = [User]()
                    if let statuses = info as! [NSDictionary]? {
                        for status in statuses {
                            let text = status["description"] as? String
                            
                            let _ = status["id"] as? Int64
                            
                            let profileImageUrl = status["profile_image_url_https"] as? String
                            let screenName = "@\(status["screen_name"] ?? "")"
                            let name = status["name"] as? String
                            let protected = status["protected"] as? Bool
                            let verified = status["verified"] as? Bool
                            
                            let url = URL(string: profileImageUrl!.replacingOccurrences(of: "_normal", with: ""))!
                            let profileImage = UIImageView()
                            profileImage.af_setImage(withURL: url, completion: { (image) in
                                following.append(User(username: screenName, name: name!, profilePhoto: profileImage.image!, following: 0, followers: 0, isProtected: protected!, isVerified: verified!, description: text!))
                            })
                        }
                        completion?(following)
                    }
                }, errorBlock: { (error) in
        
                })
    }
    
    static func getTweetInfo(by id: String?, completion: ((_ tweet: HomeStatus) -> Void)?) {
        TwitterClient.twitter?.getStatusesShowID(id, trimUser: 0, includeMyRetweet: 1, includeEntities: 1, useExtendedTweetMode: 1, successBlock: { (info) in
            if var status = info {
                var retweeted: String? = nil
                if let retweeted_status = status["retweeted_status"] {
                    let retweetedUser = status["user"] as? NSDictionary
                    retweeted = retweetedUser!["name"] as? String
                    status = (retweeted_status as! NSDictionary) as! [AnyHashable : Any]
                }
                
                var text = status["full_text"] as? String
                text = text!.replacingOccurrences(
                    of: "@(https?://([-\\w\\.]+[-\\w])+(:\\d+)?(/([\\w/_\\.#-]*(\\?\\S+)?[^\\.\\s])?)?)@",
                    with: "",
                    options: .regularExpression,
                    range: text!.startIndex ..< text!.endIndex
                )
                let retweet = status["retweet_count"] as? Int64
                let like = status["favorite_count"] as? Int64
                let id = status["id"] as? Int64
                
                if let user = status["user"] as? NSDictionary {
                    let profileImageUrl = user["profile_image_url_https"] as? String
                    let screenName = "@\(user["screen_name"] ?? "")"
                    let name = user["name"] as? String
                    let protected = user["protected"] as? Bool
                    let verified = user["verified"] as? Bool
                    
                    let url = URL(string: profileImageUrl!.replacingOccurrences(of: "_normal", with: ""))!
                    let profileImage = UIImageView()
                    profileImage.af_setImage(withURL: url, completion: { (image) in
                        completion?(HomeStatus(text: text, profileImage: profileImage.image, name: name, screenName: screenName, likes: like, retweets: retweet, isProtected: protected, isVerified: verified, in_reply_to_screen_name: "", id: id, retweetedUser: retweeted))
                    })
                }
            }
        }, errorBlock: { (error) in
            print(error as Any)
        })
    }
    static func getHomeTimeline(sinceID id: String?,completion: ((_ tweet: HomeStatus) -> Void)?) {
        TwitterClient.twitter?.verifyCredentials(userSuccessBlock: { (username, userId) -> Void in
            TwitterClient.twitter?.getHomeTimeline(sinceID: id, count: 20, successBlock: { (statuses) -> Void in
                let tatuses = statuses as! [NSDictionary]
                for var status in tatuses {
                    var retweeted: String? = nil
                    if let retweeted_status = status["retweeted_status"] {
                        let retweetedUser = status["user"] as? NSDictionary
                        retweeted = retweetedUser!["name"] as? String
                        status = retweeted_status as! NSDictionary
                    }
                    
                    let temp = status["text"] as? String
                    let text = temp!.replacingOccurrences(
                        of: "@(https?://([-\\w\\.]+[-\\w])+(:\\d+)?(/([\\w/_\\.#-]*(\\?\\S+)?[^\\.\\s])?)?)@",
                        with: "",
                        options: .regularExpression,
                        range: temp!.startIndex ..< temp!.endIndex
                    )
                    let retweet = status["retweet_count"] as? Int64
                    let like = status["favorite_count"] as? Int64
                    let id = status["id"] as? Int64
                    
                    if let user = status["user"] as? NSDictionary {
                        let profileImageUrl = user["profile_image_url_https"] as? String
                        let screenName = "@\(user["screen_name"] ?? "")"
                        let name = user["name"] as? String
                        let protected = user["protected"] as? Bool
                        let verified = user["verified"] as? Bool
                        
                        let url = URL(string: profileImageUrl!.replacingOccurrences(of: "_normal", with: ""))!
                        let profileImage = UIImageView()
                        profileImage.af_setImage(withURL: url, completion: { (image) in
                            completion?(HomeStatus(text: text, profileImage: profileImage.image, name: name, screenName: screenName, likes: like, retweets: retweet, isProtected: protected, isVerified: verified, in_reply_to_screen_name: "", id: id, retweetedUser: retweeted))
                        })
                    }
                }
            }, errorBlock: { (error) -> Void in
                print(error as Any)
            })
            
        }) { (error) -> Void in
            print(error as Any)
        }
    }
}
