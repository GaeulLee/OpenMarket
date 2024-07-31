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
//    private let selectPictureView: UIImageView = {
//        let view = UIImageView()
//        view.backgroundColor = .backColor
//        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPictureViewTapped(_:))) // UIView 클릭 제스쳐!
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        return view
//    }()
    
    private let selectPhotoBtn: UIButton = {
        let btn = UIButton()
        // 버튼 내 이미지 사이즈 조절 위함
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "camera.fill", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
        
        btn.tintColor = .lightGray
        btn.titleLabel?.textColor = .lightGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.titleLabel?.text = "0/5"
        
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.contentMode = .scaleAspectFit
        
        
        btn.addTarget(self, action: #selector(selectPhotoBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let selectPictureImage: UIImageView = {
        let view = UIImageView()
        view.image = .camera
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
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
        tf.font = .systemFont(ofSize: 16, weight: .bold)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        tf.textColor = .defaultFontColor
        tf.tintColor = .defaultFontColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let priceTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "상품 가격"
        tf.font = .systemFont(ofSize: 16, weight: .bold)
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .clear
        tf.textColor = .defaultFontColor
        tf.tintColor = .defaultFontColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 7
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "상품 설명"
        tv.font = .systemFont(ofSize: 16, weight: .bold)
        tv.backgroundColor = .clear
        tv.textColor = .systemGray3
        tv.tintColor = .defaultFontColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 7
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.autocapitalizationType = .none
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        return tv
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
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .defaultFontColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let imageScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let entireStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
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
    
    @objc private func selectPictureViewTapped(_ gesture: UITapGestureRecognizer) {
        print("selectPictureViewTapped")
    }
    
    @objc private func selectPhotoBtnTapped() {
        print("selectPhotoBtnTapped")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
        
        //contentSize 속성이 중요한가 보다,, 이미지뷰 동적 생성 시 필요
        imageScrollView.contentSize.width = (105) * CGFloat(5)

    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
        
        iNameTextfield.delegate = self
        priceTextfield.delegate = self
        descriptionTextView.delegate = self
    }
    
    private func setAddSubview() {
//        selectPictureView.addSubview(selectPictureImage)
        
//        imageScrollView.addSubview(selectPictureView)
        //imageScrollView.addSubview(imageCountLabel)
        imageScrollView.addSubview(selectPhotoBtn)
        
        entireStackView.addSubview(imageScrollView)
        entireStackView.addSubview(iNameTextfield)
        entireStackView.addSubview(priceTextfield)
        entireStackView.addSubview(descriptionTextView)
    
        self.view.addSubview(entireStackView)
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
            $0.left.equalTo(self.view.snp.left).inset(10)
        }
        vcTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top).inset(60)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        
        entireStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(entireStackView.snp.top)
            $0.width.equalTo(entireStackView.snp.width).inset(10)
            $0.centerX.equalTo(entireStackView.snp.centerX)
            $0.height.equalTo(120)
        }
        
//        selectPictureView.snp.makeConstraints {
//            $0.width.height.equalTo(100)
//            $0.centerY.equalTo(imageScrollView.snp.centerY)
//            $0.left.equalTo(imageScrollView.snp.left)
//        }
        
        selectPhotoBtn.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(imageScrollView.snp.centerY)
            $0.left.equalTo(imageScrollView.snp.left)
        }
        
        // ======================================================  test
//        selectPictureView1.snp.makeConstraints {
//            $0.width.height.equalTo(100)
//            $0.centerY.equalTo(imageScrollView.snp.centerY)
//            $0.left.equalTo(selectPictureView.snp.right).inset(-5)
//        }
        // ======================================================  test
        
//        selectPictureImage.snp.makeConstraints {
//            $0.width.height.equalTo(80)
//            $0.centerX.equalTo(selectPictureView.snp.centerX)
//            $0.top.equalTo(selectPictureView.snp.top)
//        }
//        imageCountLabel.snp.makeConstraints {
//            $0.centerX.equalTo(selectPictureView.snp.centerX)
//            $0.bottom.equalTo(selectPictureView.snp.bottom).inset(8)
//        }
        
        iNameTextfield.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).inset(-15)
            $0.width.equalTo(entireStackView.snp.width).inset(10)
            $0.centerX.equalTo(entireStackView.snp.centerX)
            $0.height.equalTo(45)
        }
        
        priceTextfield.snp.makeConstraints {
            $0.top.equalTo(iNameTextfield.snp.bottom).inset(-10)
            $0.width.equalTo(entireStackView.snp.width).inset(10)
            $0.centerX.equalTo(entireStackView.snp.centerX)
            $0.height.equalTo(45)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(priceTextfield.snp.bottom).inset(-10)
            $0.width.equalTo(entireStackView.snp.width).inset(10)
            $0.centerX.equalTo(entireStackView.snp.centerX)
            $0.height.equalTo(390)
//            $0.bottom.lessThanOrEqualToSuperview()
        }

    }
    
}

extension CreateItemViewController: UITextFieldDelegate {
    
}

extension CreateItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = nil
            textView.textColor = .defaultFontColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "상품 설명"
            textView.textColor = .systemGray3
        }
    }
}
