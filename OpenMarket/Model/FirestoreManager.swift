//
//  FirestoreManager.swift
//  OpenMarket
//
//  Created by 이가을 on 8/19/24.
//

import Foundation
import FirebaseFirestore

protocol FirestoreManagerDelegate {
    // 가입 성공
    // 가입 실패
    // 중복 데이터
    // 일반 에러
    
    func loginSuccessed()
    func loginFailed()
}


final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    var delegate: FirestoreManagerDelegate?
    
    let db = Firestore.firestore()
    
    // ========================================== login
    public func login(id: String, pw: String) {
        let query = db.collection(K.DB.collectionName).whereField(K.DB.MemberField.Id, isEqualTo: id).whereField(K.DB.MemberField.Pw, isEqualTo: pw)
        query.getDocuments { qs, error in
            if let error = error {
                // fail
                print(error.localizedDescription)
                return
            } else {
                // success
                if qs!.documents.isEmpty {
                    print("로그인 실패")
                    self.delegate?.loginFailed()
                
                } else {
                    print("로그인 성공")
                    self.delegate?.loginSuccessed()
                }
            }
        }
    }
    
    // ========================================== member
    // create
    public func checkDuplication(with: String, fieldName: String) -> Bool {
        var result = false
        
        let query = db.collection(K.DB.collectionName).whereField(fieldName, isEqualTo: with)
        query.getDocuments { qs, error in
            if let error = error {
                // fail
                print(error.localizedDescription)
                return
            } else {
                // success
                if qs!.documents.isEmpty {
                    print("데이터 중복 X")
                    result = true
                
                } else {
                    print("데이터 중복!")
                }
            }
        }
        
        return result
    }

    
    public func createMember(_ newMember: Member) {
        db.collection(K.DB.collectionName).document(newMember.memberID)
            .setData([ K.DB.MemberField.Id: newMember.memberID,
                       K.DB.MemberField.Pw: newMember.memberPW,
                       K.DB.MemberField.Name: newMember.memberName,
                       K.DB.MemberField.Nickname: newMember.memberNickname,
                       K.DB.MemberField.Email: newMember.memberEmail ]) { error in
            if let error = error {
                // fail
                print(error.localizedDescription)
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
