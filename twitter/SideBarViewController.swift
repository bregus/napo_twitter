//
//  SideBarViewController.swift
//  twitter
//
//  Created by Рома Сумороков on 15/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {
    
    weak var delegate: MenuSelected?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePhoto.setImage(User.profilePhoto, for: .normal)
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
        profilePhoto.imageView?.layer.cornerRadius = profilePhoto.frame.width / 2
        
        name.text = User.name
        username.text = User.username
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        var attributedText = NSMutableAttributedString(string: "\(User.following)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: " Following", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        followingButton.setAttributedTitle(attributedText, for: .normal)
        
        attributedText = NSMutableAttributedString(string: "\(User.followers)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: " Follower", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        followerButton.setAttributedTitle(attributedText, for: .normal)
    }

    @IBAction func profilePhotoTapped(_ sender: Any) {
        delegate?.buttonTapped(with: 0)
    }
    @IBAction func followingButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(with: 1)
    }
    @IBAction func followersButtonTapped(_ sender: Any) {
        delegate?.buttonTapped(with: 2)
    }
    
}

extension SideBarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.gray
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Profile"
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "Bookmarks"
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = "Moments"
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = "Follower requests"
            }
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Settings and privacy"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewTapped(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

protocol MenuSelected: class {
    func tableViewTapped(at indexPath: IndexPath)
    func buttonTapped(with id: Int)
}
