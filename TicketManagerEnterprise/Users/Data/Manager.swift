//
//  Manager.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/26/22.
//

import Foundation

class Manager: User {
    var email: String
    
    var id: UUID
    
    var firstName: String
    
    var lastName: String
    
    var accountType: UserType = .manager
    
}
