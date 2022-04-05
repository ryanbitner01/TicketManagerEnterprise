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

private struct UserRegistrationRequest: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var uuid: String
    var accountType: String
}

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
            
    // MARK: Add User
    
    func saveUser(email: String, firstName: String, lastName: String, uuid: String) {
        let jsonData = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "uuid": uuid,
            "accountType": "user"
        ]
        db.collection("requests").document().setData(jsonData)
    }
    
    func registerUser(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { _, err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.CheckLogin(username: email, password: password) { result in
                    switch result {
                    case.success(let email):
                        print("logged in: \(email)")
                    case .failure(let err):
                        print(err.localizedDescription)
                        if err == .NotVerified {
                            self.sendVerificationEmail()
                        }
                    }
                }
            }
        }
    }
    
    func checkForDuplicateEmailInFirestore(email: String, completion: @escaping (Bool) -> Void) {
        functions.httpsCallable("checkForDuplicateEmails").call(["email": email]) { result, err in
            if let result = result {
                if let data = result.data as? Bool {
                    completion(data)
                } else {
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: Login User
    
    func setRememberedEmail(rememberMe: Bool, email: String) {
        if rememberMe {
            UserDefaults.standard.userEmail = email
        }
    }
    
    func setRememberMe(_ rememberMe: Bool) {
        UserDefaults.standard.rememeberMe = rememberMe
    }
    
    func getRemmemberedEmail() -> String? {
        return UserDefaults.standard.userEmail
    }
    
    func getRememberMe() -> Bool? {
        return UserDefaults.standard.rememeberMe
    }
    
    func CheckLogin(username: String, password: String, completion: @escaping (Result<String, UserServiceError>) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { authDataResult, err in
            if let err = err {
                print(err.localizedDescription)
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
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { qs, err in
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
    
    var rememeberMe: Bool {
        get {
            self.bool(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
}
