//
//  LoginUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/22/22.
//

import UIKit
import SwiftUI

class LoginUserViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var incorrectUserLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userService: UserService = UserService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        showIncorrectPasswordLabel()
//        userService.CheckLogin(username: emailTextField.text!, password: passwordTextField.text!) { result in
//            switch result {
//            case .success(let email):
//                self.userService.login(email: email) { loginSuccessful in
//                    if loginSuccessful {
//                        //LOGIN
//                    } else {
//                        return
//                    }
//                }
//            case .failure(_):
//                DispatchQueue.main.async {
//                    self.showIncorrectPasswordLabel()
//                }
//            }
//        }
    }
    
    func showIncorrectPasswordLabel() {
        //incorrectUserLabel.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.incorrectUserLabel.transform = CGAffineTransform(translationX: 0, y: -10)
            self.incorrectUserLabel.transform = CGAffineTransform.identity
            
        }, completion: nil)
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


