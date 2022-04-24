//
//  OrgListViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/22/22.
//

import Foundation

class OrgListViewModel {
    var orgs = [Org]() {
        didSet {
            self.searchOrgs(queriedText)
        }
    }
    
    var orgsQueried = [Org]() {
        didSet {
            self.updateView()
        }
    }
    
    let orgService = OrgService()
    
    var queriedText = "" {
        didSet {
            self.searchOrgs(queriedText)
        }
    }
    
    weak var parent: OrgListViewController?
    
    func getOrgsList() {
        orgService.getAllOrgList { result in
            switch result {
            case .success(let orgs):
                self.orgs = orgs
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func searchOrgs(_ text: String) {
        if text != "" {
            let queried = orgs.filter({
                $0.name.lowercased().contains(text.lowercased()) || String($0.id).lowercased().contains(text.lowercased())
            })
            self.orgsQueried = queried
        } else {
            self.orgsQueried = orgs
        }
    }
    
    func updateView() {
        if let parent = parent {
            parent.updateView()
        }
    }
}
