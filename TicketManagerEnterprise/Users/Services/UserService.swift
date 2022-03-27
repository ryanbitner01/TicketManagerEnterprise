//
//  UserController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FileProvider

enum UserServiceError: Error {
    case NoEmail
    case NotVerified
    case LoginNotValid
    case NoAccountType
    case NoDoc
    case NoUser
    case CantGetData
}

extension UserServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .NoEmail:
            return "Could not download the email"
        case .NotVerified:
            return "Email is not verified"
        case .LoginNotValid:
            return "Username or Password is incorrect"
        case .NoAccountType:
            return "No account type found"
        case .NoDoc:
            return "No Document Snapshot"
        case .NoUser:
            return "No User Found"
        case .CantGetData:
            return "Couldn't get data from JSON"
        }
    }
}

class UserService {
    
    var user: User?
    
    static var instance: UserService = UserService()
    
    // MARK: Add User
    
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

    // MARK: Login User

    func setRememberedEmail(rememberMe: Bool, email: String) {
        if rememberMe {
            UserDefaults.standard.userEmail = email
        }
    }
    
    func getRemmemberedEmail() -> String? {
        return UserDefaults.standard.userEmail
    }
    
    func CheckLogin(username: String, password: String, completion: @escaping (Result<String, UserServiceError>) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { authDataResult, err in
            if err != nil {
                completion(.failure(.LoginNotValid))
            } else if let authDataResult = authDataResult {
                print("Logged In")
                guard let email = authDataResult.user.email else { return completion(.failure(.NoEmail)) }
                if !authDataResult.user.isEmailVerified {
                    return completion(.failure(.NotVerified))
                }
                completion(.success(email))
            }
        }
    }
    
    func getUser(email: String, completion: @escaping (Result<User, UserServiceError>) -> Void) {
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { qs, err in
            if let qs = qs {
                let doc = qs.documents[0]
                let data = doc.data()
                let accountType = data["accountType"] as? String
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    switch accountType {
                    case String(describing: AccountType.admin):
                        let user = try JSONDecoder().decode(Admin.self, from: jsonData)
                        completion(.success(user))
                    default:
                        completion(.failure(.NoAccountType))
                    }
                } catch let err {
                    print(err.localizedDescription)
                    completion(.failure(.CantGetData))
                }
                
                
            } else if err != nil {
                return completion(.failure(.NoDoc))
            }
        }
    }
    
    func login(email: String, completion: @escaping (UserServiceError?) -> Void) {
        getUser(email: email) { result in
            switch result {
            case .success(let user):
                self.user = user
                completion(nil)
            case .failure(let err):
                completion(err)
            }
        }
    }
    
    func Logout() {
        do {
        try Auth.auth().signOut()
        } catch let err as NSError {
            fatalError("ERROR \(err.localizedDescription)")
        }
    }
    
    func sendVerificationEmail() {
        auth.currentUser?.sendEmailVerification(completion: { err in
            if err != nil {
                fatalError("Could not send Verification Email!")
            }
        })
    }
}

extension UserDefaults {
    var userEmail: String? {
        get {
            self.string(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
}
