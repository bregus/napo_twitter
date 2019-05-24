//
//  FollowListTableViewController.swift
//  twitter
//
//  Created by Рома Сумороков on 17/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class FollowListTableViewController: UITableViewController {

    var users: [User]?
    var dataType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTableViewCell.register(for: tableView)
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        users = [User]()
        if dataType == 1 {
            navigationItem.title = "Following"
            Requests.getFollowing(completion: { (following) in
                self.users?.append(following)
                self.tableView.reloadData()
            })
        }
        if dataType == 2 {
            navigationItem.title = "Followers"
            Requests.getFollowers(completion: { (follower) in
                self.users?.append(follower)
                self.tableView.reloadData()
            })
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as! UserTableViewCell
        cell.setup(user: users![indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
