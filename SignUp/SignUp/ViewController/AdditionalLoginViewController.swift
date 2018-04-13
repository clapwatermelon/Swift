//
//  AdditionalLoginViewController.swift
//  SignUp
//
//  Created by 박수현 on 12/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class AdditionalLoginViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var beforeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date: Date = self.datePicker.date
        let dateString: String = self.dateFormatter.string(from: date)
        self.dateLabel.text = dateString
        
        self.beforeButton.addTarget(self, action: #selector(touchedBeforeButton), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(touchedCancelButton), for: .touchUpInside)
    }
    
    
    @IBAction func didDatePickerValueChanged(_ sender: Any) {
        let date: Date = self.datePicker.date
        let dateString: String = self.dateFormatter.string(from: date)
        self.dateLabel.text = dateString
        
    }
    
    @IBAction func touchedSignUpButton(_ sender: Any) {
        if telephone.text!.isEmpty || dateLabel.text!.isEmpty {
            signUpButton.isEnabled = false
        } else {
            UserInformation.shared.telephone = telephone.text
            UserInformation.shared.birth = dateLabel.text
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func touchedBeforeButton() {
        UserInformation.shared.telephone = telephone.text
        UserInformation.shared.birth = dateLabel.text

        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func touchedCancelButton() {
        UserInformation.shared.id = nil
        UserInformation.shared.password = nil
        UserInformation.shared.telephone = nil
        UserInformation.shared.birth = nil
        self.dismiss(animated: true, completion: nil)
    }
}
