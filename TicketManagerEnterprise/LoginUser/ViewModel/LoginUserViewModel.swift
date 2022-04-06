//
//  LoginUserViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

class LoginUserViewModel {
    var email: String
    var password: String
    var rememberMe: Bool
    
    init(email: String = "", password: String = "", rememberMe: Bool = false) {
        self.email = email
        self.password = password
        self.rememberMe = rememberMe
    }
    
    let userService = UserService()
    
    // MARK: Login Validation
    
    func checkValidLogin(completion: @escaping (UserServiceError?) -> Void) {
        userService.CheckLogin(username: self.email, password: self.password) { result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let err):
                completion(err)
            }
        }
    }
    
    // MARK: Remebered Email
    
    func getRememberMe() -> Bool {
        return userService.getRememberMe() ?? false
    }
    
    func getRememberedEmail() -> String {
        return userService.getRemmemberedEmail() ?? ""
    }
    
    func setRememberedEmail() {
        self.userService.setRememberedEmail(rememberMe: self.rememberMe, email: self.email)
    }
    
    func setRememberMe() {
        self.userService.setRememberMe(self.rememberMe)
    }
    
}
