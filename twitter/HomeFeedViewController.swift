//
//  ViewController.swift
//  twitter
//
//  Created by Рома Сумороков on 10/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit
import HidingNavigationBar
import STTwitter
import AlamofireImage

class HomeFeedViewController: UIViewController {
    
    weak var delegate: SideMenuDelegate?
    var homeStatuses: [HomeStatus]?
    
    @IBOutlet weak var tableView: UITableView!
    var hidingNavBarManager: HidingNavigationBarManager?
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let image = User.profilePhoto.resize(targetSize: CGSize(width: 35, height: 35))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.imageView?.layer.cornerRadius = button.frame.width / 2
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        profileButton.addTarget(self, action: #selector(HomeFeedViewController.profileButtonTapped(sender:)), for: .touchDown)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        TweetTableViewCell.register(for: tableView)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.delegate = self
        
        homeStatuses = [HomeStatus]()
        
        TwitterClient.twitter?.getFollowersForScreenName("mEeLAmQbdmlqejh", successBlock: { (info) in
            print(info)
        }, errorBlock: { (error) in
            
        })
        TwitterClient.twitter?.getFriendsForScreenName("mEeLAmQbdmlqejh", successBlock: { (info) in
            print(info)
        }, errorBlock: { (error) in
            
        })
        TwitterClient.twitter?.getUserInformation(for: "mEeLAmQbdmlqejh", successBlock: { (info) in
            //let e = info! as NSDictionary
            //print(e)
        }, errorBlock: { (error) in
            
        })
        TwitterClient.twitter?.verifyCredentials(userSuccessBlock: { (username, userId) -> Void in
            TwitterClient.twitter?.getHomeTimeline(sinceID: nil, count: 10, successBlock: { (statuses) -> Void in
                let tatuses = statuses as! [NSDictionary]
                print(tatuses[0])
                for status in tatuses {
                    let text = status["text"] as? String
                    let retweet = status["retweet_count"] as? Int64
                    let like = status["favorite_count"] as? Int64
                    
                    if let user = status["user"] as? NSDictionary {
                        let profileImageUrl = user["profile_image_url_https"] as? String
                        let screenName = user["screen_name"] as? String
                        let name = user["name"] as? String
                        let protected = user["protected"] as? Bool
                        let verified = user["verified"] as? Bool
                        
                        let url = URL(string: profileImageUrl!.replacingOccurrences(of: "_normal", with: ""))!
                        let profileImage = UIImageView()
                        //profileImage.af_setImage(withURL: url)
                        profileImage.af_setImage(withURL: url, completion: { (image) in
                            self.homeStatuses?.append(HomeStatus(text: text, profileImage: profileImage.image, name: name, screenName: screenName, likes: like, retweets: retweet, isProtected: protected, isVerified: verified, in_reply_to_screen_name: ""))
                            self.tableView.reloadData()
                        })
                        //profileImage.image = profileImage.image?.resize(targetSize: CGSize(width: 50, height: 50))
                        
                        
                    }
                }
                self.tableView.reloadData()
            }, errorBlock: { (error) -> Void in
                print(error as Any)
            })
            
        }) { (error) -> Void in
            print(error as Any)
        }
        //let extensionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        //extensionView.backgroundColor = .red
        //hidingNavBarManager?.addExtensionView(extensionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        
        return true
    }
    
    @objc func profileButtonTapped(sender: UIButton!) {
        delegate?.SideMenuClicked()
    }
    
}
extension HomeFeedViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeStatuses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier) as! TweetTableViewCell
        
        cell.setup(tweet: homeStatuses![indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeFeedViewController: HidingNavigationBarManagerDelegate{
    func hidingNavigationBarManagerDidChangeState(_ manager: HidingNavigationBarManager, toState state: HidingNavigationBarState) {
        
    }
    
    func hidingNavigationBarManagerDidUpdateScrollViewInsets(_ manager: HidingNavigationBarManager) {
        
    }
    
    func hidingNavigationBarManagerShouldUpdateScrollViewInsets(_ manager: HidingNavigationBarManager, insets: UIEdgeInsets) -> Bool {
        return true
    }
}
