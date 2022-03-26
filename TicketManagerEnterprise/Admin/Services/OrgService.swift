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

protocol OrgService {
    var orgArray: [Org] {get}
    var orgListVCDelegate: OrgListVCDelegate? {get set}
    
    func getAllOrgList()
}

class OrgServiceFirebase: OrgService {
    
    var orgListVCDelegate: OrgListVCDelegate?
    
    static let instance = OrgServiceFirebase()
    
    var orgArray: [Org] {
        didSet {
            orgListVCDelegate?.updateView()
        }
    }

    let orgServiceDB = db.collection("Orginizations")
    
    init() {
        self.orgArray = [Org]()
        getAllOrgList()
    }
    
    func getAllOrgList() {
        self.fetchOrgListFromFirestore { result in
            switch result {
            case .success(let orgs):
                DispatchQueue.main.async {
                    self.orgArray = orgs
                }
            case .failure(let err):
                print(err.localizedDescription)
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
    
    
}
