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
        }
    }
}

class UserService {
    
    var user: User?
    
    static var instance: UserService = UserService()
    
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
                guard let accountType = data["accountType"] as? String,
                      let uuidString = data["uuid"] as? String,
                      let uuid = UUID(uuidString: uuidString) else {
                    return completion(.failure(.NoAccountType))
                }
                switch accountType {
                case String(describing: AccountType.admin):
                    let admin = Admin(email: email, uuid: uuid)
                    completion(.success(admin))
                default:
                    completion(.failure(.NoAccountType))
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
