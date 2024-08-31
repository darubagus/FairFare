//
//  BillServices.swift
//  FairFare
//
//  Created by Daru Bagus Dananjaya on 31/08/24.
//

import Foundation
import FirebaseFirestore

struct BillItem: Codable {
    let name: String
    let amount: Double
    let paidBy: String
    let sharedBy: [String]
}

struct Bill: Codable {
    let id: String?
    let creatorId: String
    let groupId: String?
    let totalAmount: Double
    let currency: String
    let date: Date
    let description: String
    let participants: [String]
    let items: [BillItem]
    let splits: [String:Double]
    let status: String
    let createdAt: Date
    let updatedAt: Date
    
    func toDictionary() -> [String:Any] {
        let itemDicts = items.map { item -> [String: Any] in
            return [
                "name": item.name,
                "amount": item.amount,
                "paidBy": item.paidBy,
                "sharedBy": item.sharedBy
            ]
        }
        
        var dict: [String:Any] = [
                "creatorId": creatorId,
                "groupId": groupId ?? [],
                "totalAmount": totalAmount,
                "currency": currency,
                "date": Timestamp(date: date),
                "description": description,
                "participants": participants,
                "items": itemDicts,
                "splits": splits,
                "status": status,
                "createdAt": Timestamp(date: createdAt),
                "updatedAt": Timestamp(date: updatedAt)
        ]
        
        if let groupId = groupId {
            dict["groupId"] = groupId
        }
        
        return dict
    }
    
}

class BillServices {
    private let db = Firestore.firestore()
    
    func saveBill(_ bill: Bill, completion: @escaping (Result<Void, Error>) -> Void) {
        let billData = bill.toDictionary()
        
        db.collection("bills").document(bill.creatorId).setData(billData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getBills(for userID: String, completion: @escaping (Result<[Bill], Error>) -> Void) {
        db.collection("bills").whereField("participants", arrayContains: userID).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                let bills = snapshot?.documents.compactMap { document -> Bill? in
                     let data = document.data()
                     
                     // Parse the Firestore data into a Bill object
                     guard let creatorId = data["creatorId"] as? String,
                           let totalAmount = data["totalAmount"] as? Double,
                           let currency = data["currency"] as? String,
                           let dateTimestamp = data["date"] as? Timestamp,
                           let description = data["description"] as? String,
                           let participants = data["participants"] as? [String],
                           let itemsData = data["items"] as? [[String: Any]],
                           let splits = data["splits"] as? [String: Double],
                           let status = data["status"] as? String,
                           let createdAtTimestamp = data["createdAt"] as? Timestamp,
                           let updatedAtTimestamp = data["updatedAt"] as? Timestamp else {
                         return nil
                     }
                     
                     let items = itemsData.compactMap { itemData -> BillItem? in
                         guard let name = itemData["name"] as? String,
                               let amount = itemData["amount"] as? Double,
                               let paidBy = itemData["paidBy"] as? String,
                               let sharedBy = itemData["sharedBy"] as? [String] else {
                             return nil
                         }
                         return BillItem(name: name, amount: amount, paidBy: paidBy, sharedBy: sharedBy)
                     }
                     
                     return Bill(id: document.documentID,
                                 creatorId: creatorId,
                                 groupId: data["groupId"] as? String,
                                 totalAmount: totalAmount,
                                 currency: currency,
                                 date: dateTimestamp.dateValue(),
                                 description: description,
                                 participants: participants,
                                 items: items,
                                 splits: splits,
                                 status: status,
                                 createdAt: createdAtTimestamp.dateValue(),
                                 updatedAt: updatedAtTimestamp.dateValue())
                 } ?? []
                 
                 completion(.success(bills))
            }
        }
    }
    
}
