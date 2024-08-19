//
//  K.swift
//  OpenMarket
//
//  Created by 이가을 on 7/16/24.
//

import Foundation

struct K {
    // static
    static let tableViewCellID = "ItemTableViewCell"
    static let collectionViewCellID = "ItemCollectionViewCell"
    static let itemCellID = "ItemImageCollectionViewCell"
    
    struct DB {
        static let collectionName = "member"
        static let subCollectionName = "item"
        
        struct MemberField {
            static let Id = "memberID"
            static let Pw = "memberPW"
            static let Name = "memberName"
            static let Nickname = "memberNickname"
            static let Email = "memberEmail"
        }
        
        struct ItemField {
            static let Name = "itemName"
            static let Price = "itemPrice"
            static let Desc = "description"
            static let Date = "date"
            static let MemberID = "memberID"
            static let Image = "itemImage"
        }
    }
}
