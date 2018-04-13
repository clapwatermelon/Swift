//
//  LoginViewController.swift
//  SignUp
//
//  Created by 박수현 on 12/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.idField.text = UserInformation.shared.id
    }
}
