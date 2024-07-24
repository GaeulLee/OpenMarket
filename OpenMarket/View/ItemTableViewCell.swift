//
//  ItemTableViewCell.swift
//  OpenMarket
//
//  Created by 이가을 on 7/17/24.
//

import UIKit
import SnapKit

class ItemTableViewCell: UITableViewCell {

    // MARK: - property
    public var item: Item? {
        didSet {
            INameLabel.text = item?.itemName
            priceLabel.text = item?.itemPrice        }
    }

    
    // MARK: - UI elements
    private let uiView: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        return view
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .btnColor
        return view
    }()
    
//    let pImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private let INameLabel: UILabel = {
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
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 7
        return sv
    }()
    
    
    // MARK: - override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setAddSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - private
    private func setAddSubview() {
        labelUIView.addSubview(INameLabel)
        labelUIView.addSubview(priceLabel)
        
        stackView.addArrangedSubview(testView)
//        stackView.addArrangedSubview(pImageView)
        stackView.addArrangedSubview(labelUIView)
        
        uiView.addSubview(stackView)
        self.addSubview(uiView)
    }
    
    private func setConstraints() {
        INameLabel.snp.makeConstraints {
            $0.top.equalTo(labelUIView.snp.top).inset(3)
        }
        
        priceLabel.snp.makeConstraints {
            $0.bottom.equalTo(labelUIView.snp.bottom).inset(3)
        }
        
        testView.snp.makeConstraints {
            $0.height.width.equalTo(90)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalTo(uiView.snp.edges).inset(5)
        }
        
        uiView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
