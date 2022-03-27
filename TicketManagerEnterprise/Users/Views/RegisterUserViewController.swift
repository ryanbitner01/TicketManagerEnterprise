//
//  RegisterUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/27/22.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var firstNameBlankLabel: UILabel!
    @IBOutlet weak var lastNameBlankLabel: UILabel!
    @IBOutlet weak var invalidEmailLabel: UILabel!
    @IBOutlet weak var invalidPasswordLabel: UILabel!
    @IBOutlet weak var passwordMatchLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    let userService: UserService = UserService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        self.initializeView()
        // Do any additional setup after loading the view.
    }
    
    func initializeView() {
        self.invalidEmailLabel.isHidden = true
        self.invalidPasswordLabel.isHidden = true
        self.passwordMatchLabel.isHidden = true
        self.lastNameBlankLabel.isHidden = true
        self.firstNameBlankLabel.isHidden = true
    }
    
    func shouldSave() -> Bool {
        let requirements = checkRequirements()
        return requirements
    }
    
    func checkRequirements() -> Bool {
        let validEmail = userService.emailVerification(emailTextField.text!)
        let validPassword = userService.passwordVerification(passwordTextField.text!)
        let passwordMatch = userService.passwordMatch(password1: passwordTextField.text!, password2: retypePasswordTextField.text!)
        let firstNameEmpty = !firstNameTextField.text!.isEmpty
        let lastNameEmpty = !lastNameTextField.text!.isEmpty
        invalidEmailLabel.isHidden = validEmail
        invalidPasswordLabel.isHidden = validPassword
        passwordMatchLabel.isHidden = passwordMatch
        firstNameBlankLabel.isHidden = firstNameEmpty
        lastNameBlankLabel.isHidden = lastNameEmpty
        
        return validEmail && validPassword && passwordMatch && firstNameEmpty && lastNameEmpty
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let shouldSave = shouldSave()
        if shouldSave {
            saveUser()
        }
    }
    
    func saveUser() {
        
    }

}
