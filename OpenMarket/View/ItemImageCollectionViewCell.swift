//
//  ItemImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이가을 on 8/5/24.
//

import UIKit

class ItemImageCollectionViewCell: UICollectionViewCell {
    // MARK: - UI elements
    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .btnColor
        return view
    }()
    
    //    let pImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        return imageView
    //    }()
    
    public func setupCell(img: UIImage?) {
        setupLayout()
    }
    
}

private extension ItemImageCollectionViewCell {
    func setupLayout() {

        self.addSubview(testView)
        
        testView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
}

