//
//  CreateItemViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit
import BSImagePicker
import Photos


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
    
    private var uploadedImageCnt: Int = 0
    private var images: [UIImage] = [] // 선택된 이미지를 담을 배열
    private let imageShooter = UIImagePickerController() // 촬영사진 사용
    
    
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
        btn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        return btn
    }()
    
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
        
        // 이미지 배열 재설정
        self.images = []
        
        // 사진 다중 선택 위한 ImagePickerController 생성 및 설정
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5 - self.uploadedImageCnt
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        print("imagePicker.settings.selection.max -> \(imagePicker.settings.selection.max)")

        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "사진 촬영", style: .default, handler: { UIAlertAction in
            // UIImagePickerController
            self.imageShooter.sourceType = .camera
            self.present(self.imageShooter, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "사진 선택", style: .default, handler: { UIAlertAction in
            // ImagePickerController(외부 라이브러리 사용)
            self.presentImagePicker(imagePicker, select: { (asset) in
                // User selected an asset. Do something with it. Perhaps begin processing/upload?
            }, deselect: { (asset) in
                // User deselected an asset. Cancel whatever you did when asset was selected.
            }, cancel: { (assets) in
                // User canceled selection.
            }, finish: { (assets) in
                // User finished selection assets.
                self.addImagesToCollectionView(assets)
            })
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    private func addImagesToCollectionView(_ assets: [PHAsset]) {
        if assets.count == 0 { return }

        for i in 0..<assets.count {
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            var thumbnail = UIImage()
            
            imageManager.requestImage(for: assets[i],
                                      targetSize: CGSize(width: 100, height: 2100),
                                      contentMode: .aspectFit,
                                      options: option) { (result, info) in
                thumbnail = result!
            }
            
            let data = thumbnail.jpegData(compressionQuality: 0.7)
            let newImage = UIImage(data: data!)
            
            self.images.append(newImage! as UIImage)
        }
        self.uploadedImageCnt = assets.count
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.selectPhotoBtn.setTitle("\(self.uploadedImageCnt)/5", for: .normal)
            print("self.uploadedImageCnt-> \(self.uploadedImageCnt)")
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBSImagePicker()
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setBSImagePicker() {
        
        
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
            $0.left.equalTo(selectPhotoBtn.snp.right).inset(3)
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
            self.images.append(image)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.selectPhotoBtn.setTitle("\(self.uploadedImageCnt)/5", for: .normal)
                print("self.uploadedImageCnt-> \(self.uploadedImageCnt)")
            }
            
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
//            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension CreateItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
}
extension CreateItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.itemCellID, for: indexPath) as? ItemImageCollectionViewCell else {
            fatalError("Failed to load cell!")
        }
        cell.setupCell(img: self.images[indexPath.row])
        return cell
    }
    
}
