//
//  AlertMessageExtension.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/22/22.
//

import Foundation

class AlertMessageService {
    static let instance = AlertMessageService()

    func fatalErrorMessage(err: Error) {
        
        fatalError("ERROR: \(err.localizedDescription)")
    }
}
