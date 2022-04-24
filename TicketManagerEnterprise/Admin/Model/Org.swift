//
//  Org.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import Foundation

struct Org: Identifiable, Codable {
    var name: String
    let id: Int
    let provisioned: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "orgName"
        case id = "orgID"
        case provisioned = "provisioned"
    }
}
