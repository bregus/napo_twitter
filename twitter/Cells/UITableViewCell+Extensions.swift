import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

extension UITableViewCell {
    
    static func register(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
}
