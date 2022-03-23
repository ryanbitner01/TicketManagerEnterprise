//
//  LoginUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/22/22.
//

import UIKit
import SwiftUI

class LoginUserViewController: UIViewController {
    
    enum SegueIdentifier: String {
        case ToAdminUserVC
        case ToVerifyEmailVC
    }
    
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incorrectUserLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userService: UserService = UserService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRememberedEmail()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        setRememberMeState()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        checkValidLogin()
    }
    
    func checkValidLogin() {
        userService.CheckLogin(username: emailTextField.text!, password: passwordTextField.text!) { result in
            switch result {
            case .success(let email):
                self.login(email: email)
            case .failure(let err):
                DispatchQueue.main.async {
                    switch err {
                    case .LoginNotValid:
                        self.showIncorrectPasswordLabel()
                    case .NotVerified:
                        self.segueFromLoginVC(segueId: .ToVerifyEmailVC)
                    default:
                        self.showAlertWithMessage(err.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
    func login(email: String) {
        self.userService.login(email: email) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlertWithMessage(err.errorDescription!)
                }
            } else {
                DispatchQueue.main.async {
                    self.userService.setRememberedEmail(rememberMe: self.rememberMeButton.isSelected, email: email)
                    self.segueFromLoginVC(segueId: .ToAdminUserVC)
                }
            }
        }
    }
    
    func segueFromLoginVC(segueId: SegueIdentifier) {
        performSegue(withIdentifier: segueId.rawValue, sender: self)
    }
    
    func showIncorrectPasswordLabel() {
        incorrectUserLabel.isHidden = false
        incorrectUserLabel.bounceAnimation(repeatCount: 1)
    }
    
    func getRememberedEmail() {
        if let email = userService.getRemmemberedEmail() {
            emailTextField.text = email
            rememberMeButton.isSelected = true
        } else {
            rememberMeButton.isSelected = false
        }
    }
    
    func setRememberMeState() {
        rememberMeButton.isSelected.toggle()
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


