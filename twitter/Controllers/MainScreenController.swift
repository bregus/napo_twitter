//
//  MainScreenController.swift
//  twitter
//
//  Created by Рома Сумороков on 10/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class MainScreenController: UIViewController, SideMenuDelegate, MenuSelected {
    
    @IBOutlet weak var blackoutMainScreen: UIButton!
    
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRigthContraint: NSLayoutConstraint!
    
    var wasOpened = false
    var navigationContainerController: HomeFeedViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.borderWidth = 0.5
        sideMenuWidthConstraint.constant = view.frame.width - 50
        let rightEdgePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        view.addGestureRecognizer(rightEdgePanGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SideBarViewController,
            segue.identifier == "MenuSegue" {
            vc.delegate = self
            //delegateStore?.delegate = self as MenuSelected
            
        }
        if segue.identifier == "NavigationSegue"
        {
            let navc = segue.destination as? UINavigationController
            navigationContainerController = navc?.children.first as? HomeFeedViewController
            //delegateStore?.delegate = navigationContainerController.self as? MenuSelected
            navigationContainerController?.delegate = self as SideMenuDelegate
        }
    }
    
    func tableViewTapped(at At: IndexPath) {
        blackoutButtonTap((Any).self)
    }
    
    func buttonTapped(with id: Int) {
        blackoutButtonTap((Any).self)
        if id == 1 || id == 2 {
            let controller = FollowListTableViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func blackoutButtonTap(_ sender: Any) {
        self.containerViewLeadingConstraint.constant = 0
        self.containerRigthContraint.constant = 0
        sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
        blackoutMainScreen.alpha = 0.0
        wasOpened = false
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
        })
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            
            blackoutMainScreen.alpha = (sideMenuWidthConstraint.constant - (-1 * sideMenuLeadingConstraint.constant)) / (sideMenuWidthConstraint.constant + 400)
            if !wasOpened {
                containerViewLeadingConstraint.constant = 0 + translation.x
                containerRigthContraint.constant = 0 - translation.x
            } else if wasOpened {
                containerViewLeadingConstraint.constant = sideMenuWidthConstraint.constant + translation.x
                containerRigthContraint.constant = -sideMenuWidthConstraint.constant - translation.x
            }
            
            sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
            if containerViewLeadingConstraint.constant >= sideMenuWidthConstraint.constant {
                containerViewLeadingConstraint.constant = sideMenuWidthConstraint.constant
                containerRigthContraint.constant = -sideMenuWidthConstraint.constant
                sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
                return
            }
            if containerViewLeadingConstraint.constant <= 0 {
                containerViewLeadingConstraint.constant = 0
                containerRigthContraint.constant = 0
                sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
                return
            }
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            if self.containerViewLeadingConstraint.constant > (sideMenuWidthConstraint.constant/2) {
                self.containerViewLeadingConstraint.constant = sideMenuWidthConstraint.constant
                self.containerRigthContraint.constant = -sideMenuWidthConstraint.constant
                wasOpened = true

                blackoutMainScreen.alpha = 0.4
            } else {
                self.containerViewLeadingConstraint.constant = 0
                self.containerRigthContraint.constant = 0
                wasOpened = false
                blackoutMainScreen.alpha = 0
            }
            sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.view.layoutIfNeeded()
            })
        }
    }
    
    func SideMenuClicked() {
        containerViewLeadingConstraint.constant = sideMenuWidthConstraint.constant
        containerRigthContraint.constant = -sideMenuWidthConstraint.constant
        sideMenuLeadingConstraint.constant = containerViewLeadingConstraint.constant - sideMenuView.frame.width
        blackoutMainScreen.alpha = 0.4
        wasOpened = true
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.view.layoutIfNeeded()
        })
    }
}
