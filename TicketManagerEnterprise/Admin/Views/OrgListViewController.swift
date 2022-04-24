//
//  OrgListViewController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import UIKit

class OrgListViewController: UIViewController {
    
    var orgModel = OrgListViewModel()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var searchTextBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
        searchTextBar.delegate = self
        self.hideKeyboardTappedAround()
        self.refreshData()
        self.orgModel.parent = self
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.listView.reloadData()
        }
    }
    
    @IBAction func resfreshButtonPressed(_ sender: Any) {
        self.refreshData()
    }
    
    func refreshData() {
        orgModel.getOrgsList()
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
        return orgModel.orgsQueried.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrgListTableViewCell.cellIdentifier, for: indexPath) as? OrgListTableViewCell else {return UITableViewCell()}
        let org = orgModel.orgsQueried[indexPath.row]
        let cellVM = OrgListCellViewModel(provisioned: org.provisioned, orgName: org.name, orgID: "\(org.id)")
        cell.viewModel = cellVM
        cell.updateCell()
        return cell
    }
    
    
}

extension OrgListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        orgModel.queriedText = searchBar.text ?? ""
    }
}
