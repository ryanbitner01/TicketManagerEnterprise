//
//  OrgService.swift
//  TicketManagerEnterprise
//
//  Created by Ryan Bitner on 3/25/22.
//

import Foundation
import Firebase

private enum OrgError: Error {
    case NoOrgs
}

extension OrgError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .NoOrgs:
            return "Can't retrieve the orginization list"
        }
    }
}

class OrgService {

    let orgServiceDB = db.collection("Orgs")
    
    func getAllOrgList(completion: @escaping (Result<[Org], Error>) -> Void) {
        self.fetchOrgListFromFirestore { result in
            switch result {
            case .success(let orgs):
                DispatchQueue.main.async {
                    completion(.success(orgs))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    private func fetchOrgListFromFirestore(completion: @escaping (Result<[Org], OrgError>) -> Void) {
        orgServiceDB.getDocuments { qs, err in
            if let qs = qs {
                let docs = qs.documents
                let orgs = docs.compactMap { qds -> Org? in
                    let dict = qds.data()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        let org = try JSONDecoder().decode(Org.self, from: jsonData)
                        return org
                    } catch let err {
                        print(err.localizedDescription)
                        return nil
                    }
                }
                completion(.success(orgs))
            } else if err != nil {
                completion(.failure(.NoOrgs))
            }
        }
    }
    
    // MARK: NEW ORG
    func createOrg(orgName: String, completion: @escaping (Bool) -> Void) {
        getOrgID { id in
            guard let id = id else {return completion(false)}
            let requestsRef = db.collection("OrgRequests")
            let ownerEmail = Auth.auth().currentUser?.email
            let data: [String: Any] = [
                "orgName": orgName,
                "orgOwner": ownerEmail!,
                "orgID": id,
                "provisioned": false,
            ]
            requestsRef.document().setData(data)
            completion(true)
        }
        
    }
    
    func getOrgID(completion: @escaping (Int?) -> Void) {
        functions.httpsCallable("getOrgID").call { result, err in
            if let result = result {
                if let data = result.data as? Int {
                    completion(data+1)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
}
