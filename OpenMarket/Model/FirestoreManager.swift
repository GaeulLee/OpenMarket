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
    
    private func IDCheck(_ id: String){ // true: 가입 진행(중복 없음), false: 가입 불가(중복 있음)
        // 아이디 중복 확인
        /*
            read에는 pull/push 방식이 있음
            1. push - 한 컬렉션의 특정 도큐먼트의 데이터를 불러옴(읽고자 하는 도큐먼트 id 필요)
            => db.collection(K.DB.collectionName).document("읽고자 하는 도큐먼트 id").getDocuments {}
            2. pull - 한 컬렉션의 모든 도큐먼트(id!)를 불러옴(모든 도큐먼트를 불러오기 때문에 특정 도큐먼트 id가 필요 없음)
                => db.collection(K.DB.collectionName).getDocuments {}
        */
        
//        db.collection(K.DB.collectionName).getDocuments { snapshot, error in // pull
//            if let error = error {
//                // fail
//                print(error.localizedDescription)
//            } else {
//                // success
//                guard let result = snapshot else { // 도큐먼트가 없으면
//                    // 데이터가 없음(alert)
//                    print("no documents!")
//                    return
//                }
//                
//                for document in result.documents { // 도큐먼트가 존재하면 중복된 아이디 있는지 확인
//                    if document.documentID == id { // 아이디 중복!
//                        print("\(document.documentID)는 존재하는 아이디!")
//                    }
//                }
//            }
//        }
        
        


    }
    
    // create
    public func createMember(_ newMember: Member) {
        // 아이디 중복 확인
        let query = db.collection(K.DB.collectionName).whereField(K.DB.MemberField.Id, isEqualTo: newMember.memberID)
        query.getDocuments { qs, error in
            if let error = error {
                // fail
                print(error.localizedDescription)
                return
            } else {
                // success
                if qs!.documents.isEmpty {
                    print("데이터 중복 안 됨. 가입 진행 가능")
                    self.db.collection(K.DB.collectionName).document(newMember.memberID)
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
                } else {
                    print("데이터 중복! 가입 진행 불가")
                }
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
