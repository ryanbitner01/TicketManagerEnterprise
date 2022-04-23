//
//  CreateOrgViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

class CreateOrgViewModel {
    var orgName: String
    
    var orgService = OrgServiceFirebase()
    
    init(orgName: String = "") {
        self.orgName = orgName
    }
    
    func createOrg(completion: @escaping (Bool) -> Void) {
        orgService.createOrg(orgName: self.orgName) {didComplete in
            completion(didComplete)
        }
    }
    
    func checkRequirements() -> Bool {
        if orgName.count > 3 {
            return true
        } else {
            return false
        }
    }
}
