//
//  Admin.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation

class Admin: User, Codable {
    
    var email: String
    
    var id: UUID
    
    init (email: String, uuid: UUID) {
        self.email = email
        self.id = uuid
    }
    
}
