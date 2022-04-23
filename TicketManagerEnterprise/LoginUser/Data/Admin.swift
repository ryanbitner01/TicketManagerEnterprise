//
//  Admin.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation

class Admin: User, Codable {
    
    var firstName: String
    
    var lastName: String
    
    var email: String
    
    var accountType: UserType = .admin
    
  //  var id: UUID
    
    init (email: String, uuid: UUID, firstName: String, lastName: String) {
        self.email = email
        //self.id = uuid
        self.firstName = firstName
        self.lastName = lastName
    }
    
}
