//
//  CreateItemViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct CreateItemViewController_Preview: PreviewProvider {
    static var previews: some View {
        CreateItemViewController().toPreview()
    }
}
#endif

class CreateItemViewController: UIViewController {

    // MARK: - Property
    var test: String? {
        didSet {
            vcTitleLabel.text = test
        }
    }

    
    // MARK: - UI element
    private let selectPictureView: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // ======================================================  test
    private let selectPictureView1: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    private let selectPictureView2: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    private let selectPictureView3: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    private let selectPictureView4: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    // ======================================================  test
    
    
    private let selectPictureImage: UIImageView = {
        let view = UIImageView()
        view.image = .camera
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let vcTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let iNameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "상품명"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let priceTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "상품 가격"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let descriptionTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "상품 설명"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let createItemBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("상품 등록하기", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(createItemBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let imageScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let entireScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false 
        return sv
    }()
    
    
    
    // MARK: - objc
    @objc private func createItemBtnTapped() {
        print("createItemBtnTapped")
    }

    @objc private func closeBtnTapped() {
        print("closeBtnTapped")
        self.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
        
        //contentSize 속성이 중요한가 보다,, 이미지뷰 동적 생성 시 필요
        imageScrollView.contentSize.width = (105) * CGFloat(5)
        entireScrollView.contentSize.height = 1000
    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
    }
    
    private func setAddSubview() {
        selectPictureView.addSubview(selectPictureImage)
        
        imageScrollView.addSubview(selectPictureView)
        imageScrollView.addSubview(selectPictureView1)
        imageScrollView.addSubview(selectPictureView2)
        imageScrollView.addSubview(selectPictureView3)
        imageScrollView.addSubview(selectPictureView4)
        imageScrollView.addSubview(imageCountLabel)
        
        entireScrollView.addSubview(imageScrollView)
        entireScrollView.addSubview(iNameTextfield)
        entireScrollView.addSubview(priceTextfield)
        entireScrollView.addSubview(descriptionTextfield)
    
        self.view.addSubview(entireScrollView)
        self.view.addSubview(createItemBtn)
        self.view.addSubview(closeBtn)
        self.view.addSubview(vcTitleLabel)
    }
    
    private func setConstraints() {
        createItemBtn.snp.makeConstraints {
            $0.left.equalTo(self.view.snp.left).inset(15)
            $0.right.equalTo(self.view.snp.right).inset(15)
            $0.bottom.equalTo(self.view.snp.bottom).inset(30)
            $0.height.equalTo(45)
        }
        closeBtn.snp.makeConstraints { // 버튼으로 수정!
            $0.top.equalTo(self.view.snp.top).inset(60)
            $0.left.equalTo(self.view.snp.left)
        }
        vcTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top).inset(60)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        entireScrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(entireScrollView.snp.top)
            $0.width.equalTo(entireScrollView.snp.width).inset(10)
            $0.centerX.equalTo(entireScrollView.snp.centerX)
            $0.height.equalTo(120)
        }
        selectPictureView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(imageScrollView.snp.left)
        }
        
        // ======================================================  test
        selectPictureView1.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(selectPictureView.snp.right).inset(-5)
        }
        selectPictureView2.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(selectPictureView1.snp.right).inset(-5)
        }
        selectPictureView3.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(selectPictureView2.snp.right).inset(-5)
        }
        selectPictureView4.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(selectPictureView3.snp.right).inset(-5)
        }
        // ======================================================  test
        
        selectPictureImage.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalTo(selectPictureView.snp.centerX)
            $0.top.equalTo(selectPictureView.snp.top)
        }
        imageCountLabel.snp.makeConstraints {
            $0.centerX.equalTo(selectPictureView.snp.centerX)
            $0.bottom.equalTo(selectPictureView.snp.bottom).inset(8)
        }
        
        iNameTextfield.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).inset(-15)
            $0.width.equalTo(entireScrollView.snp.width).inset(10)
            $0.centerX.equalTo(entireScrollView.snp.centerX)
            $0.height.equalTo(45)
        }
        
        priceTextfield.snp.makeConstraints {
            $0.top.equalTo(iNameTextfield.snp.bottom).inset(-10)
            $0.width.equalTo(entireScrollView.snp.width).inset(10)
            $0.centerX.equalTo(entireScrollView.snp.centerX)
            $0.height.equalTo(45)
        }
        
        descriptionTextfield.snp.makeConstraints {
            $0.top.equalTo(priceTextfield.snp.bottom).inset(-10)
            $0.width.equalTo(entireScrollView.snp.width).inset(10)
            $0.centerX.equalTo(entireScrollView.snp.centerX)
            $0.height.equalTo(600)
        }
        

    }

}
