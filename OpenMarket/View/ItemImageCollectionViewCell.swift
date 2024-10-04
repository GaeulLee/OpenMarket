//
//  ItemImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이가을 on 8/5/24.
//

import UIKit

class ItemImageCollectionViewCell: UICollectionViewCell {
    
    var btnEvent: (() -> Void) = {} // ⭐️
    
    // MARK: - UI elements
    private let pImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.black.cgColor
        btn.backgroundColor = .white
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(didSelectDeleteBtn), for: .touchUpInside) // ⭐️
        return btn
    }()
    
    @objc private func didSelectDeleteBtn() { // ⭐️
        btnEvent()
    }
    
    public func setupCell(img: UIImage?) {
        pImageView.image = img
        setupLayout()
    }
    
}

private extension ItemImageCollectionViewCell {
    func setupLayout() {

        self.addSubview(pImageView)
        self.addSubview(deleteBtn)
        
        pImageView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        deleteBtn.snp.makeConstraints {
            $0.right.equalTo(pImageView.snp.right).inset(3)
            $0.top.equalTo(pImageView.snp.top).inset(3)
            $0.width.height.equalTo(20)
        }
    }
}

