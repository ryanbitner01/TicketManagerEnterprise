//
//  RegisterUserViewModel.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 4/5/22.
//

import Foundation

enum RegistrationError: Error {
    case duplicateEmail
    case invalidEmail
    case invalidPassword
    case emptyFirstName
    case emptyLastName
    case passwordMatch
}


class RegisterUserViewModel {
    var email: String
    var password: String
    var confirmPassword: String
    var firstName: String
    var lastName: String
    
    init(email: String = "", password: String = "", confirmPassword: String = "", firstName: String = "", lastName: String = "") {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.firstName = firstName
        self.lastName = lastName
    }
    
    let userService = UserService()
    
    func registerNewUser() {
        userService.saveUser(email: self.email, firstName: self.firstName, lastName: self.lastName, uuid: UUID().uuidString)
        userService.registerUser(email: self.email, password: self.password)
    }
    
    func checkValidData(completion: @escaping ([RegistrationError]) -> Void) {
        checkDuplicateEmail { duplicate in
            DispatchQueue.main.async {
                completion(self.checkFields(duplicateEmail: duplicate))
            }
        }
    }
    
    func checkFields(duplicateEmail: Bool) -> [RegistrationError] {
        var errors = [RegistrationError]()
        let validEmail = self.emailVerification(self.email)
        let validPassword = self.passwordVerification(self.password)
        let passwordMatch = self.passwordMatch(password1: self.password, password2: self.confirmPassword)
        let firstNameEmpty = self.firstName.isEmpty
        let lastNameEmpty = self.lastName.isEmpty
        if !validEmail {
            errors.append(.invalidEmail)
        }
        if duplicateEmail && validEmail {
            errors.append(.duplicateEmail)
        }
        if !validPassword {
            errors.append(.invalidPassword)
        }
        if !passwordMatch {
            errors.append(.passwordMatch)
        }
        if firstNameEmpty {
            errors.append(.emptyFirstName)
        }
        if lastNameEmpty {
            errors.append(.emptyLastName)
        }
        return errors
    }
    
    func checkDuplicateEmail(completion: @escaping (Bool) -> Void) {
        userService.checkForDuplicateEmailInFirestore(email: self.email) { duplicate in
            completion(duplicate)
        }
    }
    
    // MARK: Data Validation
    
    func passwordVerification(_ text: String) -> Bool {
        let requirements = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", requirements).evaluate(with: text)
    }
    
    func emailVerification(_ text: String) -> Bool {
        let requirements = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", requirements).evaluate(with: text)
    }
    
    func passwordMatch(password1: String, password2: String) -> Bool {
        return password1 == password2
    }
    
    
}
