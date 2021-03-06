//
//  User.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation

enum AccountType: String {
    case admin
}

protocol User {
    var email: String {get set}
    var id: UUID {get}
    
}
