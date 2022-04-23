//
//  VerifyEmailViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

class VerifyEmailViewModel {
    var email: String
    var userService = UserService()
    
    init(email: String) {
        self.email = email
    }
    
    func sendVerificationEmail() {
        userService.sendVerificationEmail()
    }
}
