//
//  RegisterUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/27/22.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
    enum segueID: String {
        case verifyEmail = "ToVerifyEmailVC"
    }
    
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
    
    var viewModel = RegisterUserViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        self.hideAlerts()
        // Do any additional setup after loading the view.
    }
    
    func clearText() {
        self.emailTextField.text = ""
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.passwordTextField.text = ""
        self.retypePasswordTextField.text = ""
    }
    
    func hideAlerts() {
        self.invalidEmailLabel.isHidden = true
        self.invalidPasswordLabel.isHidden = true
        self.passwordMatchLabel.isHidden = true
        self.lastNameBlankLabel.isHidden = true
        self.firstNameBlankLabel.isHidden = true
    }
    
    func checkRequirements() {
        updateViewModel()
        hideAlerts()
        viewModel.checkValidData { errors in
            if errors.isEmpty {
                self.saveUser()
            }
            else {
                for error in errors {
                    self.handleRegistrationAlert(error)
                }
            }
        }
    }
    
    func handleRegistrationAlert(_ error: RegistrationError) {
        switch error {
        case .invalidEmail:
            self.showEmailLabel(message: .invalidFormat)
        case .duplicateEmail:
            self.showEmailLabel(message: .duplicateEmail)
        case .invalidPassword:
            self.invalidPasswordLabel.isHidden = false
        case .passwordMatch:
            self.passwordMatchLabel.isHidden = false
        case .emptyLastName:
            self.lastNameBlankLabel.isHidden = false
        case .emptyFirstName:
            self.firstNameBlankLabel.isHidden = false
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
    
    func updateViewModel() {
        viewModel = RegisterUserViewModel(
            email: emailTextField.text!,
            password: passwordTextField.text!,
            confirmPassword: retypePasswordTextField.text!,
            firstName: firstNameTextField.text!,
            lastName: lastNameTextField.text!)
    }
    
    func saveUser() {
        viewModel.registerNewUser()
        self.clearText()
        self.performSegue(withIdentifier: segueID.verifyEmail.rawValue , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID.verifyEmail.rawValue {
            let verifyEmailVC = segue.destination as! VerifyEmailViewController
            verifyEmailVC.viewModel = VerifyEmailViewModel(email: self.viewModel.email)
            
        }
    }
    
}
