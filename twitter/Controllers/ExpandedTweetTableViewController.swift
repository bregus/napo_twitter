//
//  ExpandedTweetTableViewController.swift
//  twitter
//
//  Created by Рома Сумороков on 24/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class ExpandedTweetTableViewController: UITableViewController {

    var tweet: HomeStatus? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        TweetExpandedTableViewCell.register(for: tableView)
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetExpandedTableViewCell.identifier) as! TweetExpandedTableViewCell
        cell.setup(tweet: tweet!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
