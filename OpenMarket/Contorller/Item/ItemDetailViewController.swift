//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ItemDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        ItemDetailViewController().toPreview()
    }
}
#endif


class ItemDetailViewController: UIViewController {
    // MARK: - property
    var item: Item? {
        didSet {
            iNameLabel.text = item?.itemName
            priceLabel.text = item?.itemPrice
            memberIDLabel.text = item?.memberID
            descLabel.text = item?.description
        }
    }
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        return button
    }()
    
    
    // MARK: - UI element
    private let scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      return scrollView
    }()
    
    private var imageView: UIImageView = {
        let img = UIImageView()
        img.image = .appIcon
        return img
    }()
    
    private var iNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private var memberIDLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .defaultFontColor        
        return label
    }()
    
    private var descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .defaultFontColor
        label.numberOfLines = 0
        label.setContentHuggingPriority(.init(rawValue: 252), for: .vertical)

        return label
    }()
    
    private var priceAndIDLabelView: UIView = {
        let view = UIView()
        return view
    }()

    
    // MARK: - objc
    @objc private func editButtonTapped() {
        print("editButtonTapped")
        let vc = CreateItemViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
        setUIBarButtonItem()
    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
    }

    private func setAddSubview() {
        priceAndIDLabelView.addSubview(priceLabel)
        priceAndIDLabelView.addSubview(memberIDLabel)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(iNameLabel)
        scrollView.addSubview(priceAndIDLabelView)
        scrollView.addSubview(descLabel)
        self.view.addSubview(scrollView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(7)
        }

        imageView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(scrollView.snp.width)
            
        }
        
        iNameLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(imageView.snp.bottom).inset(-5)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        priceAndIDLabelView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(iNameLabel.snp.bottom).inset(-5)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        priceLabel.snp.makeConstraints {
            $0.left.equalTo(priceAndIDLabelView.snp.left)
            $0.centerY.equalTo(priceAndIDLabelView.snp.centerY)
        }
        
        memberIDLabel.snp.makeConstraints {
            $0.right.equalTo(priceAndIDLabelView.snp.right)
            $0.centerY.equalTo(priceAndIDLabelView.snp.centerY)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(priceAndIDLabelView.snp.bottom).inset(-20)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func setUIBarButtonItem() {
        if item?.memberID == "seller1" {
            // db연결하고 글 작성자인 경우만(글 작성자와 현재 글을 보고있는 사용자가 일치하는지 확인) 수정 버튼 활성화
            self.navigationItem.rightBarButtonItem = self.editButton
        }
    }
}
