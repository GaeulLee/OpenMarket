//
//  FirestoreManager.swift
//  OpenMarket
//
//  Created by 이가을 on 8/19/24.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    // ========================================== member
    // create
    public func createMember(_ newMember: Member) {
        // 아이디 있는지 확인 후 없으면 계정 추가 진행
        db.collection(K.DB.collectionName).document(newMember.memberID)
            .setData([ K.DB.MemberField.Id: newMember.memberID,
                       K.DB.MemberField.Pw: newMember.memberPW,
                       K.DB.MemberField.Name: newMember.memberName,
                       K.DB.MemberField.Nickname: newMember.memberNickname,
                       K.DB.MemberField.Email: newMember.memberEmail ]) { error in
            if let error = error {
                // fail
            } else {
                // success
                print("\(newMember.memberID) added")
            }
        }
    }
    
    // read
    public func readMember() -> [Member]? {
        return nil
    }
    
    // update
    public func updateMember() {
        
    }
    
    // delete
    public func deleteMember() {
        
    }
    
    // ========================================== item
    // create
    public func createItem(newItem: Item) {
        db.collection(K.DB.collectionName).document(newItem.memberID)
            .collection(K.DB.subCollectionName).addDocument(data: [ K.DB.ItemField.Name: newItem.itemName,
                                                                    K.DB.ItemField.Price: newItem.itemPrice,
                                                                    K.DB.ItemField.Desc: newItem.description,
                                                                    K.DB.ItemField.Date: newItem.date,
                                                                    K.DB.ItemField.MemberID: newItem.memberID,
                                                                    K.DB.ItemField.Image: newItem.itemImage ]) { error in
            if let error = error {
                // fail
            } else {
                // success
                print("\(newItem.itemName) added")
            }
        }
    }
    
    // read
    
    // update
    
    // delete
    
    // ========================================== image
    // create
    
    // read
    
    // update
    
    // delete
}
