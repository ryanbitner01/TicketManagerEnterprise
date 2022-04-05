//
//  UserTypes.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

enum UserType: String, Codable {
    case admin = "Admin"
    case user = "User"
    case manager = "Manager"
    case moderator = "Moderator"
    case agent = "Agent"
}
