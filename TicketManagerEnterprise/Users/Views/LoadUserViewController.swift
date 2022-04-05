//
//  LoadUserViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import UIKit

class LoadUserViewController: UIViewController {
    
    var viewModel: LoadUserViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getUser() {
        viewModel?.getUser() { success in
            if success {
                let identifier = self.viewModel?.loadUser()
                if let identifier = identifier {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: identifier, sender: self.viewModel)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertWithMessage("Could not Load User") { action in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewModel = viewModel {
            switch viewModel.user?.accountType {
            default:
                return
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

}
