//
//  HideKeyboardExtension.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/26/22.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
