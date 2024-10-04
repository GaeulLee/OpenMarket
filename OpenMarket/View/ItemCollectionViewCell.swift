//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이가을 on 7/18/24.
//

import UIKit


class ItemCollectionViewCell: UICollectionViewCell {
    // MARK: - UI elements
    let iImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let labelUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
    
    
    public func setupCell(item: Item) {
        // cell 세팅(데이터,화면 등)
        iNameLabel.text = item.itemName
        priceLabel.text = item.itemPrice
        iImageView.image = item.itemImage[0] // 배열의 첫번째 사진으로 고정
        
        setupLayout()
    }
}


private extension ItemCollectionViewCell {
    func setupLayout() {
        labelUIView.addSubview(iNameLabel)
        labelUIView.addSubview(priceLabel)
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(iImageView)
        stackView.addArrangedSubview(labelUIView)
        
        
        iNameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelUIView.snp.top).inset(3)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(labelUIView.snp.bottom).inset(3)
        }
        
        iImageView.snp.makeConstraints { make in
            make.height.equalTo((UIScreen.main.bounds.width / 2) - 40)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(5)
        }
    }
}
