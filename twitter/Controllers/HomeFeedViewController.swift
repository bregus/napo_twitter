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
    var homeStatuses = [HomeStatus]()
    var lastTweetId: Int64?
    var updating: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    var hidingNavBarManager: HidingNavigationBarManager?
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let image = User.current.profilePhoto.resize(targetSize: CGSize(width: 35, height: 35))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.imageView?.layer.cornerRadius = button.frame.width / 2
        button.layer.cornerRadius = button.frame.width / 2
        return button
    }()
    
    @objc func onDidReceiveData(_ notification:Notification) {
        let image = User.current.profilePhoto.resize(targetSize: CGSize(width: 35, height: 35))
        profileButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("didReceiveData"), object: nil)
        profileButton.addTarget(self, action: #selector(HomeFeedViewController.profileButtonTapped(sender:)), for: .touchDown)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        TweetTableViewCell.register(for: tableView)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.delegate = self
        
        Requests.getHomeTimeline(sinceID: nil) { (tweet) in
            self.homeStatuses.append(tweet)
            self.tableView.reloadData()
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
        return homeStatuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier) as! TweetTableViewCell
        
        cell.setup(tweet: homeStatuses[indexPath.item])
        
        return cell
    }
    
    func loadMoreFeed() {
        if updating {return}
        updating = true
        let id = self.homeStatuses[homeStatuses.count - 1].id
        Requests.getHomeTimeline(sinceID: "\(id!)") { (tweet) in
            self.homeStatuses.append(tweet)
            self.tableView.reloadData()
            self.updating = false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50, scrollView.contentSize.height != 0{
            loadMoreFeed()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = ExpandedTweetTableViewController()
        Requests.getTweetInfo(by: "\(homeStatuses[indexPath.item].id!)") { (tweet) in
            controller.tweet = tweet
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
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

protocol SideMenuDelegate: class {
    func SideMenuClicked()
}
