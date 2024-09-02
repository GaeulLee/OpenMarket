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

protocol FirestoreManagerMemberInfoDelegate {
    func changeMemberInfoSuccessed()
}

protocol FirestoreManagerItemDelegate {
    func readAllItemSuccessed(_ items: [Item])
    func readOneMembersItemSuccessed(_ items: [Item])
}

protocol FirestoreManagerUploadItemDelegate {
    func uploadItemSuccessed()
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
    var memberInfoDelegate: FirestoreManagerMemberInfoDelegate?
    
    var itemDelegate: FirestoreManagerItemDelegate?
    var uploadItemDelegate: FirestoreManagerUploadItemDelegate?
    
    var errorDelegate: FirestoreManagerErrorDelegate?
    
    private var savedMemberInfo: Member?
    let db = Firestore.firestore()
    
    
    public func setMemberInfo(_ member: Member?) {
        self.savedMemberInfo = member
        print(member)
    }
    
    public func getMemberInfo() -> Member {
        return savedMemberInfo!
    }

    
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
                    if !snapshotDoc.isEmpty {
                        let data = snapshotDoc[0].data()
                        if let id = data[K.DB.MemberField.Id] as? String,
                           let pw = data[K.DB.MemberField.Pw] as? String,
                           let name = data[K.DB.MemberField.Name] as? String,
                           let nickname = data[K.DB.MemberField.Nickname] as? String,
                           let email = data[K.DB.MemberField.Email] as? String {
                            let loggedInMember = Member(memberID: id, memberPW: pw, memberName: name, memberNickname: nickname, memberEmail: email)
                            self.loginDelegate?.loginSuccessed(loggedInMember)
                            print("로그인 성공")
                        }
                    } else {
                        self.loginDelegate?.loginFailed()
                        print("로그인 실패")
                    }
                } else {
                    self.loginDelegate?.loginFailed()
                    print("로그인 실패")
                }
            }
        }
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
    public func updateMemberNickname(with memberID: String, to memberNickname: String) {
        db.collection(K.DB.collectionName).document(memberID)
            .updateData([K.DB.MemberField.Nickname: memberNickname]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("\(memberID)'s nickname changed")
                    self.savedMemberInfo?.memberNickname = memberNickname
                    self.memberInfoDelegate?.changeMemberInfoSuccessed()
                }
            }
    }
    public func updateMemberPW(with memberID: String, to memberPW: String) {
        db.collection(K.DB.collectionName).document(memberID)
            .updateData([K.DB.MemberField.Pw: memberPW]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("\(memberID)'s PW changed")
                    self.savedMemberInfo?.memberPW = memberPW
                    self.memberInfoDelegate?.changeMemberInfoSuccessed()
                }
            }
    }
    
    // delete
    public func deleteMember(with memberID: String) {
        do {
            let db = try db.collection(K.DB.collectionName).document(memberID).delete()
            print("\(memberID) deleted")
        } catch {
            print("\(memberID) delete failed")
        }
    }
    
    // ========================================== item
    // create
    public func createItem(newItem: Item) {
        let itemDocName = "\(newItem.itemName)\(newItem.date)"
        print(itemDocName)
        db.collection(K.DB.collectionName).document(newItem.memberID)
            .collection(K.DB.subCollectionName).document(itemDocName)
            .setData([K.DB.ItemField.Name: newItem.itemName,
                       K.DB.ItemField.Price: newItem.itemPrice,
                       K.DB.ItemField.Desc: newItem.description,
                       K.DB.ItemField.Date: newItem.date,
                       K.DB.ItemField.MemberID: newItem.memberID,
                       K.DB.ItemField.Image: newItem.itemImage]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.uploadItemDelegate?.uploadItemSuccessed()
                print("\(newItem.itemName) added")
            }
        }
    }
    
    // read
    public func readAllItems() {
        db.collectionGroup(K.DB.subCollectionName).getDocuments { qs, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if !qs!.documents.isEmpty {
                    let datas = qs!.documents
                    var items: [Item] = []
                    for data in datas {
                        if let name = data[K.DB.ItemField.Name] as? String,
                           let price = data[K.DB.ItemField.Price] as? String,
                           let desc = data[K.DB.ItemField.Desc] as? String,
                           let date = data[K.DB.ItemField.Date] as? String,
                           let ID = data[K.DB.ItemField.MemberID] as? String,
                           let images = data[K.DB.ItemField.Image] as? [Data] {
                            let item = Item(itemName: name, itemPrice: price, description: desc, date: date, memberID: ID, itemImage: images)
                            items.append(item)
                        }
                    }
                    self.itemDelegate?.readAllItemSuccessed(items)
                } else {
                    print("read items faild")
                }
            }
        }
        
    }
    
    public func readOneMembersItems(with memberID: String) {
        db.collectionGroup(K.DB.subCollectionName)
            .order(by: K.DB.ItemField.Date, descending: false)
            .whereField(K.DB.ItemField.MemberID, isEqualTo: memberID).getDocuments { qs, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if !qs!.documents.isEmpty {
                    let datas = qs!.documents
                    var items: [Item] = []
                    for data in datas {
                        if let name = data[K.DB.ItemField.Name] as? String,
                           let price = data[K.DB.ItemField.Price] as? String,
                           let desc = data[K.DB.ItemField.Desc] as? String,
                           let date = data[K.DB.ItemField.Date] as? String,
                           let ID = data[K.DB.ItemField.MemberID] as? String,
                           let images = data[K.DB.ItemField.Image] as? [Data] {
                            let item = Item(itemName: name, itemPrice: price, description: desc, date: date, memberID: ID, itemImage: images)
                            items.append(item)
                        }
                    }
                    self.itemDelegate?.readOneMembersItemSuccessed(items)
                } else {
                    print("read items faild")
                }
            }
        }
        
    }
    
    // update
    public func updateItem(modifiedItem: Item, prevItemName: String) {
        let oldItemDocName = "\(prevItemName)\(modifiedItem.date)"
        let newItemDocName = "\(modifiedItem.itemName)\(modifiedItem.date)"
        
        print("oldItemDocName => \(oldItemDocName)")
        print("newItemDocName => \(newItemDocName)")
        
        // 기존 데이터 삭제하고
        db.collection(K.DB.collectionName).document(modifiedItem.memberID)
            .collection(K.DB.subCollectionName).document(oldItemDocName).delete()
        print("\(oldItemDocName) deleted")
        
        // 수정된 데이터로 새롭게 생성
        db.collection(K.DB.collectionName).document(modifiedItem.memberID)
            .collection(K.DB.subCollectionName).document(newItemDocName)
            .setData([K.DB.ItemField.Name: modifiedItem.itemName,
                       K.DB.ItemField.Price: modifiedItem.itemPrice,
                       K.DB.ItemField.Desc: modifiedItem.description,
                       K.DB.ItemField.Date: modifiedItem.date,
                       K.DB.ItemField.MemberID: modifiedItem.memberID,
                       K.DB.ItemField.Image: modifiedItem.itemImage]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.uploadItemDelegate?.uploadItemSuccessed()
                print("\(modifiedItem.itemName) modified")
            }
        }
    }
    
    // delete
    public func deleteItem(with item: Item) {
        do {
            let itemDocName = "\(item.itemName)\(item.date)"
            let db = try db.collection(K.DB.collectionName).document(item.memberID)
                .collection(K.DB.subCollectionName).document(itemDocName).delete()
            print("\(item.itemName) deleted")
        } catch {
            print("\(item.itemName) delete failed")
        }
    }
    
    
    // ========================================== image
    // create
    
    // read
    
    // update
    
    // delete
}
