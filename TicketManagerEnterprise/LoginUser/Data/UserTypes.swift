//
//  UserTypes.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

enum UserType: String, Codable {
    case admin = "admin"
    case user = "user"
    case manager = "manager"
    case moderator = "moderator"
    case agent = "agent"
}
