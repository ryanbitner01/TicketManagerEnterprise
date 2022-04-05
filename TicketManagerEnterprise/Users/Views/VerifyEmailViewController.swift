//
//  VerifyEmailViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/23/22.
//

import UIKit

class VerifyEmailViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    var viewModel: VerifyEmailViewModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.text = "Verification email sent to \(viewModel!.email) Didn't Receive the verification email click bellow to resend it."

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        viewModel?.sendVerificationEmail()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
