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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserTableViewCell.register(for: tableView)
        tableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
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
