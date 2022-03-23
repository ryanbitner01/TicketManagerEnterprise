//
//  AlertMessageExtension.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/22/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .actionSheet)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
