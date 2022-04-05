//
//  LoadUserViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

class LoadUserViewModel {
    
    enum segueID: String {
        case toAdminVC = "admin"
        case toUserVC = "user"
        case toManagerVC = "manager"
        case toAgentVC = "agent"
        case toModerator = "moderator"
    }
    
    var email: String
    var user: User?
    
    let userService = UserService()
    
    init(email: String = "", accountType: String = "") {
        self.email = email
    }
    
    func getUser(completion: @escaping (Bool) -> Void) {
        userService.getUser(email: self.email) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion(true)
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
    
    func loadUser() -> String {
        if let user = user {
            switch user.accountType {
            case .user:
                return segueID.toUserVC.rawValue
            case .admin:
                return segueID.toAdminVC.rawValue
            case .manager:
                return segueID.toManagerVC.rawValue
            case .agent:
                return segueID.toAgentVC.rawValue
            case .moderator:
                return segueID.toModerator.rawValue
            }
        } else {
            return ""
        }
    }
}
