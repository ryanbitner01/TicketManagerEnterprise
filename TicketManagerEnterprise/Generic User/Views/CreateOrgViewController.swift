//
//  CreateOrgViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import UIKit

class CreateOrgViewController: UIViewController {
    
    var viewModel: CreateOrgViewModel?
    
    @IBOutlet weak var orgNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func checkRequirements() {
        updateViewModel()
        let requirements = self.viewModel?.checkRequirements() ?? false
        if requirements {
            print("SAVE ORG!")
            //self.saveOrg()
        } else {
            //DISPLAY ALERT
            print("Doesn't Meet Requirements")
        }
    }
    
    func updateViewModel() {
        self.viewModel = CreateOrgViewModel(orgName: orgNameTextField.text!)
    }
    
    func saveOrg() {
        viewModel?.createOrg()
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
