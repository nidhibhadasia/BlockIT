//
//  LoginSignUpViewController.swift
//  BlockIT
//
//  Created by Admin on 12/13/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class LoginSignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewAvatar: UIView!
    
    var isLoginView = false
    
    // MARK: - View Lifecycle
    let arLogins = [["email":"admin@blockit.com","password":"Admin123"],["email":"info@blockit.com","password":"Info123"],["email":"contact@blockit.com","password":"Contact123"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        txtEmail.text = "admin@blockit.com"
        txtPassword.text = "Admin123"
        
        if isLoginView {
            viewAvatar.isHidden = true
            self.title = "Login"
        }else {
            viewAvatar.isHidden = false
            self.title = "Signup"
        }
    }
    
   
    

    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isEmailValid = isValidEmail(testStr: txtEmail.text ?? "")
        let isPasswordValid = isValidPassword(testStr: txtPassword.text ?? "")

        if isEmailValid && isPasswordValid {
            btnSubmit.isEnabled = true
            btnSubmit.alpha = 1.0;
        }else {
            btnSubmit.isEnabled = false
            btnSubmit.alpha = 0.5;
        }
        return true
    }
    */
    
    // MARK: - Custom Methods

    func isValidPassword(testStr:String) -> Bool {
        //"^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        //let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"

        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&g]{6,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: testStr)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showAlertWithMessage(alertMessage:String)  {
        let alert = UIAlertController(title:"BlockIT", message:alertMessage,preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style:.default) { (action) in
            print("Alert default clicked")
        }
        alert.addAction(ok)
        present(alert, animated: true,completion:nil)
    }
    
    // MARK: - Image Picker Delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            imgAvatar.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imgAvatar.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Navigation

    @IBAction func avatarClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker,animated: true)
    }
    
    
    @IBAction func submitClicked(_ sender: Any) {
        
        let isEmailValid = isValidEmail(testStr: txtEmail.text ?? "")
        let isPasswordValid = isValidPassword(testStr: txtPassword.text ?? "")
        
        guard isEmailValid else {
            showAlertWithMessage(alertMessage:"Your email address is invalid. Please enter a valid address.")
            return
        }
        guard isPasswordValid else {
            showAlertWithMessage(alertMessage:"The password you’ve entered is incorrect.")
            return
        }
        
        if isEmailValid && isPasswordValid {
            let notif:SiteViewController = self.storyboard?.instantiateViewController(withIdentifier: "SiteViewController") as! SiteViewController
            self.navigationController?.pushViewController(notif, animated: true)
        }else {
           
        }
    }
}
