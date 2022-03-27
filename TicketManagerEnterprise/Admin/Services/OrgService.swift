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
    var orgArray: [Org] {get set}
    var orgQueried: [Org] {get set}
    var queryText: String {get set}
    var orgListVCDelegate: OrgListVCDelegate? {get set}
    func getAllOrgList()
    func searchOrgs(_ text: String)
}

class OrgServiceFirebase: OrgService {
    
    var orgListVCDelegate: OrgListVCDelegate?
    
    static let instance = OrgServiceFirebase()
    
    var orgArray: [Org] = [] {
        didSet {
            
        }
    }
    
    var queryText: String = "" {
        didSet {
            searchOrgs(queryText)
        }
    }
    
    var orgQueried: [Org] = [] {
        didSet {
            orgListVCDelegate?.updateView()
        }
    }

    let orgServiceDB = db.collection("Orginizations")
    
    init() {
        getAllOrgList()
    }
    
    func getAllOrgList() {
        self.fetchOrgListFromFirestore { result in
            switch result {
            case .success(let orgs):
                DispatchQueue.main.async {
                    self.orgArray = orgs
                    self.searchOrgs("")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func searchOrgs(_ text: String) {
        if text != "" {
            let queried = orgArray.filter({
                $0.name.lowercased().contains(text.lowercased()) || $0.id.lowercased().contains(text.lowercased())
            })
            self.orgQueried = queried
        } else {
            self.orgQueried = orgArray
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
