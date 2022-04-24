//
//  OrgListTableViewViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/22/22.
//

import Foundation

class OrgListCellViewModel {
    let provisioned: Bool
    let orgName: String
    let orgID: String
    
    init(provisioned: Bool = false, orgName: String = "", orgID: String) {
        self.provisioned = provisioned
        self.orgName = orgName
        self.orgID = orgID
    }
}
