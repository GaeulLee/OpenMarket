//
//  CreateItemViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit
import PhotosUI

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
    
    var uploadedImageCnt: Int = 0
    private var selections = [String : PHPickerResult]() // Dictionary (이미지 데이터 저장)
    // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장
    // selections은 딕셔너리이기 때문에 순서 X. 그래서 따로 식별자를 담을 배열 생성
    private var selectedAssetIdentifiers = [String]()

    
    // MARK: - UI element
    private let selectPhotoBtn: UIButton = {
        let btn = UIButton()
        // 버튼 내 이미지 사이즈 조절
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "camera.fill", withConfiguration: imageConfig)
        btn.setImage(image, for: .normal)
        // 버튼 내 텍스트 및 이미지 위치 조절
        btn.imageEdgeInsets = .init(top: -22.5, left: 12.5, bottom: 0, right: 0)
        btn.titleEdgeInsets = .init(top: 57, left: -70, bottom: 0, right: 0)
        
        btn.tintColor = .lightGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.setTitle("0/5", for: .normal)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
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
        tf.attributedPlaceholder = NSAttributedString(string: "상품명", attributes: [.foregroundColor: UIColor.lightGray])
        tf.font = .systemFont(ofSize: 16, weight: .regular)
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
        tf.attributedPlaceholder = NSAttributedString(string: "상품 가격", attributes: [.foregroundColor: UIColor.lightGray])
        tf.font = .systemFont(ofSize: 16, weight: .regular)
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
        tv.text = "상품에 대한 설명을 적어주세요."
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.backgroundColor = .clear
        tv.textColor = .lightGray
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
    
//    private let imageScrollView: UIScrollView = {
//        let sv = UIScrollView()
//        sv.showsHorizontalScrollIndicator = false
//        return sv
//    }()
    // 스크롤뷰가 아닌 컬렉션뷰로 구현하자
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .backColor
        cv.register(ItemImageCollectionViewCell.self, forCellWithReuseIdentifier: K.itemCellID)
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cv
    }()
    
    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let entireStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    private let imagePicker = UIImagePickerController() // 촬영사진 사용
    private lazy var PHPicker: PHPickerViewController = { // 사진첩 사진 사용
        var config = PHPickerConfiguration(photoLibrary: .shared()) // 이미지의 Identifier를 사용하기 위해서는 초기화를 shared로
        config.filter = .images // 라이브러리에서 보여줄 Assets 필터 (기본값: 이미지, 비디오, 라이브포토)
        config.selection = .ordered
        config.selectionLimit = 5 // 다중 선택 갯수 설정 (0 = 무제한)
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers // 이 동작이 있어야 PHPicker를 실행 시, 선택했던 이미지를 기억해 표시 (델리게이트 코드 참고)
        
        let picker = PHPickerViewController(configuration: config)
        return picker
        
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
        if self.uploadedImageCnt > 4 { return }
        
        let actionSheet = UIAlertController()
        
        actionSheet.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { UIAlertAction in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "사진 선택", style: .default, handler: { UIAlertAction in
            //self.imagePicker.sourceType = .photoLibrary
            //self.present(self.imagePicker, animated: true)
            
            // 사진 여러장 선택할 수 있게..
            self.present(self.PHPicker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
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
    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
        
        iNameTextfield.delegate = self
        priceTextfield.delegate = self
        descriptionTextView.delegate = self
        PHPicker.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setAddSubview() {
        topView.addSubview(selectPhotoBtn)
        topView.addSubview(collectionView)

        entireStackView.addSubview(topView)
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
            $0.left.equalTo(self.view.snp.left).inset(10)
            $0.right.equalTo(self.view.snp.right).inset(10)
            $0.bottom.equalTo(self.view.snp.bottom).inset(40)
            $0.height.equalTo(45)
        }
        closeBtn.snp.makeConstraints {
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
        
        
        topView.snp.makeConstraints {
            $0.top.equalTo(entireStackView.snp.top)
            $0.width.equalTo(entireStackView.snp.width).inset(10)
            $0.centerX.equalTo(entireStackView.snp.centerX)
            $0.height.equalTo(120)
        }
        selectPhotoBtn.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(topView.snp.centerY)
            $0.left.equalTo(topView.snp.left)
        }
        collectionView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.centerY.equalTo(topView.snp.centerY)
            $0.left.equalTo(selectPhotoBtn.snp.right)
            $0.right.equalTo(topView.snp.right)
        }
        
        
        iNameTextfield.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).inset(-10)
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
            $0.height.equalTo(400)
        }

    }
    
}

extension CreateItemViewController: UITextFieldDelegate {
    
}

extension CreateItemViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .defaultFontColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "상품에 대한 설명을 적어주세요."
            textView.textColor = .lightGray
        }
    }
}

extension CreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            self.uploadedImageCnt += 1
            
//            // UI 설정
//            DispatchQueue.main.async {
//                // 새로운 이미지 뷰 만들고
//                let view = UIImageView()
//                view.backgroundColor = .backColor
//                view.layer.cornerRadius = 10
//                view.clipsToBounds = true
//                view.layer.borderWidth = 1
//                view.layer.borderColor = UIColor.lightGray.cgColor
//                view.image = image
//                
//                self.view.addSubview(view) // 뷰에 추가!!
//                view.snp.makeConstraints { // 레이아웃 설정
//                    $0.width.height.equalTo(100)
//                    $0.centerY.equalTo(self.imageScrollView.snp.centerY)
//
//                    print("self.uploadedImageCnt-> \(self.uploadedImageCnt)")
//                    if self.uploadedImageCnt == 1 {
//                        $0.left.equalTo(self.selectPhotoBtn.snp.right).inset(-5)
//                    } else {
//                        $0.left.equalTo(self.selectPhotoBtn.snp.right).inset(-(105 * CGFloat(self.uploadedImageCnt-1)) - 5)
//                    }
//                }
//                
//                //contentSize 속성 설정, 이미지뷰 동적 생성 시 필요
//                self.imageScrollView.contentSize.width = 105 * CGFloat(self.uploadedImageCnt+1)
//                
//                // 바튼 레이블 설정
//                self.selectPhotoBtn.setTitle("\(self.uploadedImageCnt)/5", for: .normal)
//            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension CreateItemViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        // Picker의 작업이 끝난 후, 새로 만들어질 selections을 담을 변수를 생성
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            // ⭐️ 여기는 WWDC에서 3분 부분을 참고 (Picker의 사진의 저장 방식)
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        // selections에 새로 만들어진 newSelection을 넣어줍시다.
        selections = newSelections
        // Picker에서 선택한 이미지의 Identifier들을 저장 (assetIdentifier은 옵셔널 값이라서 compactMap 받음)
        // 위의 PHPickerConfiguration에서 사용하기 위해서 입니다.
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
    }
    
}

extension CreateItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
}
extension CreateItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.itemCellID, for: indexPath) as? ItemImageCollectionViewCell else {
            fatalError("Failed to load cell!")
        }
        cell.setupCell(img: nil)
        return cell
    }
    
}
