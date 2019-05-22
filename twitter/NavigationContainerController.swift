//
//  NavigationContainerController.swift
//  twitter
//
//  Created by Рома Сумороков on 10/05/2019.
//  Copyright © 2019 Рома Сумороков. All rights reserved.
//

import UIKit

class NavigationContainerController: UIViewController, MenuSelected {
    func buttonTapped(with id: Int) {
        
    }
    
    @IBOutlet weak var ScheduleView: UIView!
    @IBOutlet weak var UserView: UIView!
    @IBOutlet weak var AboutView: UIView!
    @IBOutlet weak var SettingsView: UIView!
    
    @IBAction func SideMenuTap(_ sender: Any) {
        delegate?.SideMenuClicked()
    }
    
    var rightBarBuffer: [UIBarButtonItem] = []
    
    weak var delegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func tableViewTapped(at At: IndexPath) {
        if At.section == 1 {
            if ScheduleView.isHidden {
                ScheduleView.isHidden = false
                UserView.isHidden = true
                SettingsView.isHidden = true
                AboutView.isHidden = true
                self.navigationItem.title = "Расписание"
                self.navigationItem.rightBarButtonItems = rightBarBuffer
            }
        }
        if At.section == 2 {
            if UserView.isHidden {
                self.navigationItem.title = "Пользователь"
                self.navigationItem.rightBarButtonItems = []
                UserView.isHidden = false
                ScheduleView.isHidden = true
                SettingsView.isHidden = true
                AboutView.isHidden = true
            }
        }
        if At.section == 3 && At.row == 0 {
            if SettingsView.isHidden {
                self.navigationItem.title = "Настройки"
                self.navigationItem.rightBarButtonItems = []
                UserView.isHidden = true
                ScheduleView.isHidden = true
                AboutView.isHidden = true
                SettingsView.isHidden = false
            }
        }
        if At.section == 3 && At.row == 2 {
            if AboutView.isHidden {
                self.navigationItem.title = "О приложении"
                self.navigationItem.rightBarButtonItems = []
                UserView.isHidden = true
                ScheduleView.isHidden = true
                SettingsView.isHidden = true
                AboutView.isHidden = false
            }
        }
        
        if At.section == 4  {
            let storyboard = UIStoryboard(name: "EnterScreen", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "EnterScreen")
            self.present(controller, animated:true, completion: .none)
        }
        delegate?.SideMenuClicked()
    }
}

protocol SideMenuDelegate: class {
    func SideMenuClicked()
}
