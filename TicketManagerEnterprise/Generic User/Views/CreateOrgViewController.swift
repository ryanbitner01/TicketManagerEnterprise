//
//  CreateOrgViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import UIKit

class CreateOrgViewController: UIViewController {
    
    var viewModel = CreateOrgViewModel()
    
    @IBOutlet weak var orgNameTextField: UITextField!
    @IBOutlet weak var orgInvalidLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideInvalidNameLabel()
        // Do any additional setup after loading the view.
    }
    
    func checkRequirements() {
        hideInvalidNameLabel()
        updateViewModel()
        let requirements = self.viewModel.checkRequirements()
        if requirements {
            print("SAVE ORG!")
            self.saveOrg()
        } else {
            showInvalidNameLabel()
            print("Doesn't Meet Requirements")
        }
    }
    
    func hideInvalidNameLabel() {
        self.orgInvalidLabel.isHidden = true
    }
    
    func showInvalidNameLabel() {
        self.orgInvalidLabel.isHidden = false
    }
    
    func updateViewModel() {
        self.viewModel.orgName = orgNameTextField.text!
    }
    
    func saveOrg() {
        viewModel.createOrg() {didComplete in
            if didComplete {
                DispatchQueue.main.async {
                    self.logoutFromView()
                }
            }
        }
    }
    
    @IBAction func createButtonTapped(sender: Any) {
        checkRequirements()
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
