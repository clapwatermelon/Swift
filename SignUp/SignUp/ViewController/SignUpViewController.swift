//
//  SignUpViewController.swift
//  SignUp
//
//  Created by 박수현 on 12/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate , UITextViewDelegate {
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.idField.delegate = self
        self.passwordField.delegate = self
        self.checkPasswordField.delegate = self
        self.introTextView.delegate = self
        self.nextButton.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        self.nextButton.addTarget(self, action: #selector(navigateToAdditionalLoginInfo), for: .touchUpInside)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func imageViewTapped() {
        self.present(self.imagePicker, animated: true, completion: nil)
       
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = editedImage
            nextButton.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
 
    func touchUpNextButton() -> Bool{
        if imageView.image == nil || introTextView.text.isEmpty {
            nextButton.isEnabled = false
            return false
        } else {
            nextButton.isEnabled = true
            return true
        }
    }
    
    func checkPassword() -> Bool {
        if passwordField.text == checkPasswordField.text {
            return true
        }
        return false
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        if idField.text!.isEmpty || passwordField.text!.isEmpty || checkPasswordField.text!.isEmpty {
                nextButton.isEnabled = false
        } 
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if introTextView.text.isEmpty {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    @objc func navigateToAdditionalLoginInfo() {
        if touchUpNextButton() && checkPassword(){
            self.nextButton.isEnabled = true
            UserInformation.shared.id = idField.text
            UserInformation.shared.password = passwordField.text
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdditionalLoginViewController") as! AdditionalLoginViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func tapView(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

}
