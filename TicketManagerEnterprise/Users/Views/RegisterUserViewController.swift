//
//  RegisterUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/27/22.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
    enum InvalidEmailMessage: String {
        case duplicateEmail = "A user with this email already exists"
        case invalidFormat = "This is not a valid email address"
    }

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
    var shouldSave: Bool = false {
        didSet {
            saveUser()
        }
    }
    
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
    
    func checkOtherRequirements(duplicateEmail: Bool) -> Bool {
        let validEmail = self.userService.emailVerification(self.emailTextField.text!)
        let validPassword = self.userService.passwordVerification(self.passwordTextField.text!)
        let passwordMatch = self.userService.passwordMatch(password1: self.passwordTextField.text!, password2: self.retypePasswordTextField.text!)
        let firstNameEmpty = !self.firstNameTextField.text!.isEmpty
        let lastNameEmpty = !self.lastNameTextField.text!.isEmpty
        DispatchQueue.main.async {
            self.invalidPasswordLabel.isHidden = validPassword
            self.passwordMatchLabel.isHidden = passwordMatch
            self.firstNameBlankLabel.isHidden = firstNameEmpty
            self.lastNameBlankLabel.isHidden = lastNameEmpty
            if duplicateEmail {
                self.showEmailLabel(message: .duplicateEmail)
            } else if !validEmail {
                self.showEmailLabel(message: .invalidFormat)
            }
        }
        return validEmail && validPassword && passwordMatch && firstNameEmpty && lastNameEmpty && !duplicateEmail
    }
    
    func checkRequirements() {
        userService.checkForDuplicateEmailInFirestore(email: emailTextField.text!) { duplicate in
            if !duplicate {
                let requirements = self.checkOtherRequirements(duplicateEmail: duplicate)
                self.shouldSave = requirements
            }
            else {
                DispatchQueue.main.async {
                    let requirements = self.checkOtherRequirements(duplicateEmail: duplicate)
                    self.shouldSave = requirements
                }
            }
        }
    }
    
    func showEmailLabel(message: InvalidEmailMessage) {
        let message = message.rawValue
        self.invalidEmailLabel.text = message
        self.invalidEmailLabel.isHidden = false
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        checkRequirements()
    }
    
    func saveUser() {
        if shouldSave {
            print("SAVED")
            userService.registerUser(email: emailTextField.text!, password: passwordTextField.text!)
            userService.saveUser(email: emailTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, uuid: UUID().uuidString)
        }
    }

}
