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
    public var item: String? {
        didSet {
            pNameLabel.text = self.item
            pPriceLabel.text = "100,000원"
        }
    }

    
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
        labelUIView.addSubview(pNameLabel)
        labelUIView.addSubview(pPriceLabel)
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(testView)
//        stackView.addArrangedSubview(pImageView)
        stackView.addArrangedSubview(labelUIView)
    }
    
    private func setConstraints() {
        pNameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelUIView.snp.top).inset(3)
        }
        
        pPriceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(labelUIView.snp.bottom).inset(3)
        }
        
        testView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(5)
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
