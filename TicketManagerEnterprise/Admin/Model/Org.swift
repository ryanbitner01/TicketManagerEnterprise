//
//  Org.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import Foundation

struct Org: Identifiable, Codable {
    var name: String
    let id: String
    
    var users: [String]
}
