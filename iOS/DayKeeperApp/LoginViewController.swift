//
//  LoginViewController.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 3/5/22.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginLabel)
    }
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()

        label.frame = CGRect(x: 0, y: 0, width: 95, height: 39)

        label.backgroundColor = .white


        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        label.font = UIFont(name: "Lemon-Regular", size: 30)
        label.text = "Login"
        return label
    }()
}
