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
            self.images = ETC.convertDataToUIImage(datas: item!.itemImage)
        }
    }
    var images: [UIImage]?
    var itemFromCreateItemVC: Item? // 업데이트한 아이템 정보 받기 위한 변수
    
    var fStoreManager = FirestoreManager.shared
    
    
    // MARK: - UI element
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(editButtonTapped))
        return button
    }()
    
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
        pc.hidesForSinglePage = true
        pc.pageIndicatorTintColor = .systemGray
        pc.currentPageIndicatorTintColor = .white
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
            vc.item = self.item
            vc.naviStack = self.navigationController?.viewControllers // ⭐️
            print(self.navigationController?.viewControllers)
            
            self.present(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { UIAlertAction in
            self.fStoreManager.deleteItem(with: self.item!)
            self.navigationController?.popViewController(animated: true) // 이전 화면으로
            
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }

    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if let item = itemFromCreateItemVC {
            self.item = item
            print(item)
            /*
             상품 정보를 수정했을 때, 이미지만 변경이 안되는 점 발견 ⭐️
             확인해보니, 데이터는 문제없이 수정된 데이터로 잘 넘어옴
             예상되는 원인은 데이터가 이미지일 경우 로드되는 속도가 느려서일 것이라 의심됨
             비동기로 이미지 로드하도록 수정해보자
             아니 근데 이미지 로드되는 속도 느린거는 이해되는데 데이터 자체는 잘 넘어온거면 이미지 배열 길이는 변경되어야하는거 아냐..?
            
            */
        }
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
            imageView.contentMode = .scaleAspectFill

            let xPosition = (self.view.frame.width - 14) * CGFloat(index)
            print(xPosition)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: (self.view.frame.width - 14),
                                     height: (self.view.frame.width - 14))

            
            imageScrollView.addSubview(imageView)
        }
        imageScrollView.contentSize.width = (self.view.frame.width - 14) * CGFloat(imgs.count)
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
            $0.width.height.equalTo(scrollView.snp.width)
            $0.top.equalTo(scrollView.snp.top)
        }
        
        imagePageControl.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(imageScrollView.snp.bottom).inset(20)
            $0.height.equalTo(10)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        imageNumberLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).inset(12)
            $0.right.equalTo(scrollView.snp.right).inset(10)
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
        if item?.memberID == fStoreManager.getMemberInfo().memberID {
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
