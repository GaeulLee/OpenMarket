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
            self.images = ECT.convertDataToUIImage(datas: item!.itemImage)
        }
    }
    
    var images: [UIImage]?
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        return button
    }()
    
    
    // MARK: - UI element
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    // image slide
    lazy var imageScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    private let imagePageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        pc.currentPageIndicatorTintColor = .white
        pc.hidesForSinglePage = true
        return pc
    }()
    private let imageNumberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.5)
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
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
        let actionSheet = UIAlertController()
        
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { UIAlertAction in
            let vc = CreateItemViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.test = "게시물 수정"
            // 작성된 글 정보 전달!!
            self.present(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { UIAlertAction in
            // 삭제 로직
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }

    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
        setImageSlider(images)
        setUIBarButtonItem()
    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
    }
    
    func setImageSlider(_ images: [UIImage]?) { // scrolliVew에 imageView 추가하는 함수
        guard let imgs = images else {
            print("기본 이미지로")
            return
        }
        
        imageScrollView.delegate = self
        imagePageControl.numberOfPages = imgs.count
        imageNumberLabel.text = "\(imagePageControl.currentPage+1)/\(imagePageControl.numberOfPages)"
        
        for index in 0..<imgs.count {
            let imageView = UIImageView()
            imageView.image = imgs[index]
            imageView.contentMode = .scaleAspectFit

            let xPosition = (self.view.frame.width - 20) * CGFloat(index)
            print(xPosition)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: (self.view.frame.width - 10),
                                     height: (self.view.frame.width - 100))

            imageScrollView.contentSize.width = (self.view.frame.width - 20) * CGFloat(index+1)
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func setAddSubview() {
        priceAndIDLabelView.addSubview(priceLabel)
        priceAndIDLabelView.addSubview(memberIDLabel)
        
        scrollView.addSubview(imageScrollView)
        scrollView.addSubview(iNameLabel)
        scrollView.addSubview(priceAndIDLabelView)
        scrollView.addSubview(descLabel)
        
        self.view.addSubview(scrollView)
        self.view.addSubview(imagePageControl)
        self.view.addSubview(imageNumberLabel)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(7)
        }

        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(300)
            $0.top.equalTo(scrollView.snp.top)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imagePageControl.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(imageScrollView.snp.bottom).inset(20)
            $0.height.equalTo(10)
            $0.width.equalTo(40)
        }
        
        imageNumberLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).inset(15)
            $0.right.equalTo(scrollView.snp.right).inset(15)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        
        iNameLabel.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalTo(imageScrollView.snp.bottom).inset(-5)
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

extension ItemDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView가 스와이프 될 때 발생 될 이벤트
        self.imagePageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
        self.imageNumberLabel.text = "\(imagePageControl.currentPage+1)/\(imagePageControl.numberOfPages)"
    }
}
