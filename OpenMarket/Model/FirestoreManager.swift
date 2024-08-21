//
//  FirestoreManager.swift
//  OpenMarket
//
//  Created by 이가을 on 8/19/24.
//

import Foundation
import FirebaseFirestore

protocol FirestoreManagerLoginDelegate {
    func loginSuccessed(_ loggedInMember: Member)
    func loginFailed()
}

protocol FirestoreManagerMemberDelegate {
    func signUpSuccessed()
}

protocol FirestoreManagerErrorDelegate {
    // 중복 데이터
    // 일반 에러
}

final class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    var loginDelegate: FirestoreManagerLoginDelegate?
    var memberDelegate: FirestoreManagerMemberDelegate?
    var errorDelegate: FirestoreManagerErrorDelegate?
    
    private var savedMemberInfo: Member?
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
                if let snapshotDoc = qs?.documents {
                    let data = snapshotDoc[0].data()
                    if let id = data[K.DB.MemberField.Id] as? String,
                       let pw = data[K.DB.MemberField.Pw] as? String,
                       let name = data[K.DB.MemberField.Name] as? String,
                       let nickname = data[K.DB.MemberField.Nickname] as? String,
                       let email = data[K.DB.MemberField.Email] as? String {
                        let loggedInMember = Member(memberID: id, memberPW: pw, memberName: name, memberNickname: nickname, memberEmail: email)
                        self.loginDelegate?.loginSuccessed(loggedInMember)
                    }
                    print("로그인 성공")
                } else {
                    self.loginDelegate?.loginFailed()
                    print("로그인 실패")
                }
            }
        }
    }
    
    public func setMemberInfo(_ member: Member) {
        self.savedMemberInfo = member
        print(member)
    }
    
    public func getMemberInfo() -> Member {
        return savedMemberInfo!
    }
    
    // ========================================== member
    // create
    public func checkDuplication(with: String, fieldName: String) -> Bool { // 회원가입 뷰 변경해야 함(아이디, 닉네임 중복 확인 버튼 추가)
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
                self.memberDelegate?.signUpSuccessed()
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
