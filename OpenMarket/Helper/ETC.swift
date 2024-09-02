//
//  DateFormat.swift
//  OpenMarket
//
//  Created by 이가을 on 8/28/24.
//

import Foundation
import UIKit

struct ETC {
    
    static func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = dateFormatter.string(from: date)
        
        return result
    }
    
    static func convertUIImageToData(images: [UIImage]) -> [Data] {
        var datas: [Data] = []
        for image in images {
            if let data = image.pngData() {
                datas.append(data)
            }
        }
        
        return datas
    }

    static func convertDataToUIImage(datas: [Data]) -> [UIImage] {
        var images: [UIImage] = []
        for data in datas {
            if let image = UIImage(data: data) {
                images.append(image)
            }
        }
        
        return images
    }
}
