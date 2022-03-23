//
//  UserController.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/21/22.
//

import Foundation
import Firebase
import FirebaseAuth

enum UserServiceError: Error {
    case NoEmail
    case NotVerified
    case LoginNotValid
    case NoAccountType
    case NoDoc
    case NoUser
}

extension UserServiceError: LocalizedError {
    private var errorDescription: String {
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
    
    func CheckLogin(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { authDataResult, err in
            if let err = err {
                completion(.failure(UserServiceError.LoginNotValid))
                fatalError("ERROR: \(err.localizedDescription)")
            } else if let authDataResult = authDataResult {
                print("Logged In")
                guard let email = authDataResult.user.email else { return AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NoEmail) }
                if !authDataResult.user.isEmailVerified {
                    return AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NotVerified)
                }
                completion(.success(email))
            }
        }
    }
    
    func getUser(email: String, completion: @escaping (User?) -> Void) {
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { qs, err in
            if let qs = qs {
                let doc = qs.documents[0]
                let data = doc.data()
                guard let accountType = data["accountType"] as? String, let uuidString = data["uuid"] as? String, let uuid = UUID(uuidString: uuidString) else {
                    completion(nil)
                    return AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NoAccountType)
                }
                switch accountType {
                case String(describing: AccountType.admin):
                    let admin = Admin(email: email, uuid: uuid)
                    completion(admin)
                default:
                    AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NoAccountType)
                }
                
            } else if err != nil {
                completion(nil)
                return AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NoDoc)
            }
        }
    }
    
    func login(email: String, completion: @escaping (Bool) -> Void) {
        getUser(email: email) { user in
            if let user = user {
                self.user = user
                completion(true)
            } else {
                completion(false)
                AlertMessageService.instance.fatalErrorMessage(err: UserServiceError.NoUser)
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
}
