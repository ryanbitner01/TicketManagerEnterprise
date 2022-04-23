//
//  LogoutExtension.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/21/22.
//

import Foundation
import UIKit
import FirebaseAuth

extension UIViewController {
    func logoutFromView() {
        self.performSegue(withIdentifier: LoginUserViewController.loginSegueID, sender: self)
        do {
            try auth.signOut()
        } catch let err {
            self.showAlertWithMessage(err.localizedDescription, actionHandler: nil)
        }
    }
}
