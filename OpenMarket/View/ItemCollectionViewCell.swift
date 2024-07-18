//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이가을 on 7/18/24.
//

import UIKit


class ItemCollectionViewCell: UICollectionViewCell {
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
    
    private let pNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let pPriceLabel: UILabel = {
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
    
    
    public func setupCell(item: String) {
        // cell 세팅(데이터,화면 등)
        pNameLabel.text = item
        pPriceLabel.text = "100,000원"
        
        setupLayout()
    }
}


private extension ItemCollectionViewCell {
    func setupLayout() {
        labelUIView.addSubview(pNameLabel)
        labelUIView.addSubview(pPriceLabel)
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(testView)
        stackView.addArrangedSubview(labelUIView)
        
        
        pNameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelUIView.snp.top).inset(3)
        }
        
        pPriceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(labelUIView.snp.bottom).inset(3)
        }
        
        testView.snp.makeConstraints { make in
            make.height.equalTo((UIScreen.main.bounds.width / 2) - 40)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(5)
        }
    }
}
