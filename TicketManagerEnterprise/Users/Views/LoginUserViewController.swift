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
    
    var viewModel: LoginUserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRememberedEmail()
        self.viewModel = LoginUserViewModel()
        self.hideKeyboardTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        setRememberMeState()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        checkValidLogin()
    }
    
    func updateViewModel() {
        self.viewModel = LoginUserViewModel(email: emailTextField.text!, password: passwordTextField.text!, rememberMe: rememberMeButton.isSelected)
    }
    
    func checkValidLogin() {
        updateViewModel()
        viewModel?.checkValidLogin() { err in
            if let err = err {
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
            } else {
                self.login()
            }
        }
    }
    
    func login() {
        segueFromLoginVC(segueId: .ToAdminUserVC)
    }
    
    func segueFromLoginVC(segueId: SegueIdentifier) {
        performSegue(withIdentifier: segueId.rawValue, sender: self)
    }
    
    func showIncorrectPasswordLabel() {
        incorrectUserLabel.isHidden = false
        incorrectUserLabel.bounceAnimation(repeatCount: 1)
    }
    
    func getRememberedEmail() {
        self.emailTextField.text = viewModel?.getRememberedEmail()
    }
    
    func setRememberMeState() {
        rememberMeButton.isSelected.toggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.ToVerifyEmailVC.rawValue {
            let verifyEmailVC = segue.destination as! VerifyEmailViewController
            verifyEmailVC.viewModel = VerifyEmailViewModel(email: self.viewModel?.email ?? "")
        }
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


