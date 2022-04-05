//
//  User.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation

protocol User: Codable {
    var email: String {get set}
    // var id: UUID {get}
    var firstName: String {get set}
    var lastName: String {get set}
    var accountType: UserType {get set}
}
