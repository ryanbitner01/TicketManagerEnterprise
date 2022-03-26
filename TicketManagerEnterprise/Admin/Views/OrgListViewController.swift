//
//  OrgListViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import UIKit

protocol OrgListVCDelegate {
    func updateView()
}

class OrgListViewController: UIViewController, OrgListVCDelegate {
    
    var orgService: OrgService = OrgServiceFirebase.instance

    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orgService.getAllOrgList()
        orgService.orgListVCDelegate = self
        listView.delegate = self
        listView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        listView.reloadData()
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

extension OrgListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgService.orgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrgListTableViewCell.cellIdentifier, for: indexPath) as? OrgListTableViewCell else {return UITableViewCell()}
        let org = orgService.orgArray[indexPath.row]
        cell.org = org
        cell.updateCell()
        return cell
    }
    
    
}
