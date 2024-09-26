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
    var item: Item?
    var naviStack: [UIViewController]?
    
    private var uploadedImageCnt: Int = 0
    private var images: [UIImage] = [] // 선택된 이미지를 담을 배열
    private let imageShooter = UIImagePickerController() // 촬영사진 사용
    
    var fStoreManager = FirestoreManager.shared
    
    
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
        print("createItemBtnTapped || images.count => \(images.count)")
        // 유효성 체크 ⭐️
        if iNameTextfield.text == "" || priceTextfield.text == "" || descriptionTextView.text == "" {
            print("textfield 입력 안 됨")
            return
        }
        if images.count <= 0 {
            print("이미지 입력 안 됨")
            return
        }
        
        if let item = self.item {
            var modifiedItem = Item(itemName: iNameTextfield.text!,
                            itemPrice: priceTextfield.text!,
                            description: descriptionTextView.text!,
                            date: item.date,
                            memberID: item.memberID,
                            itemImage: ETC.convertUIImageToData(images: images))
            fStoreManager.updateItem(modifiedItem: modifiedItem, prevItemName: item.itemName)
            print("modified post => \(modifiedItem)")

        } else {
            let id = fStoreManager.getMemberInfo().memberID
            var newItem = Item(itemName: iNameTextfield.text!,
                            itemPrice: priceTextfield.text!,
                            description: descriptionTextView.text!,
                            date: ETC.formatDateToString(date: Date()),
                            memberID: id,
                            itemImage: ETC.convertUIImageToData(images: images))
            fStoreManager.createItem(newItem: newItem)
            print("new post => \(newItem)")
        }
        
    }

    @objc private func closeBtnTapped() {
        self.presentingViewController?.dismiss(animated: true)
    }

    @objc private func selectPhotoBtnTapped() {
        if self.images.count > 4 { 
            let alert = UIAlertController(title: "알림", message: "업로드 가능한 이미지 갯수를 초과했습니다.", preferredStyle: .alert) // alert(set title, message, style)
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil) // make button and event
            alert.addAction(confirm) // add to alert
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 사진 다중 선택 위한 ImagePickerController 생성 및 설정
        let imagePicker = ImagePickerController()
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.max = 5 - self.images.count

        // 사진 촬영, 사진 선택 중 업로드 방식 action sheet로 물어보기
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
                if assets.count == 0 { return }
                
                // 선택된 asset을 image 타입으로 변환
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
                
                // collectionView reload
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.selectPhotoBtn.setTitle("\(self.images.count)/5", for: .normal)
                }
            })
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
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Nonitificatoin
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 20 증감 이유
            // entireStackView와 createItemBtn의 constraint 기준이 다르기 때문에 UI상 적절해 보이는 수치로 조절하기 위함
            entireStackView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50 + keyboardSize.height - 20)
            }
            descriptionTextView.snp.updateConstraints {
                $0.height.equalTo(400 - keyboardSize.height + 20)
            }
            createItemBtn.snp.updateConstraints {
                $0.bottom.equalTo(self.view.snp.bottom).inset(40 + keyboardSize.height - 20)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        entireStackView.snp.updateConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(50)
        }
        descriptionTextView.snp.updateConstraints {
            $0.height.equalTo(400)
        }
        createItemBtn.snp.updateConstraints {
            $0.bottom.equalTo(self.view.snp.bottom).inset(40)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - private
    private func setData() {
        if let item = self.item {
            vcTitleLabel.text = "게시물 수정"
            createItemBtn.setTitle("수정 완료", for: .normal)
            
            iNameTextfield.text = item.itemName
            priceTextfield.text = item.itemPrice
            descriptionTextView.text = item.description
            self.images = ETC.convertDataToUIImage(datas: item.itemImage)
            
            DispatchQueue.main.async {
                self.descriptionTextView.textColor = .defaultFontColor
                
                self.collectionView.reloadData()
                self.selectPhotoBtn.setTitle("\(self.images.count)/5", for: .normal)
            }

        } else {
            vcTitleLabel.text = "새 게시물 작성"
        }
    }
    
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
        
        iNameTextfield.delegate = self
        priceTextfield.delegate = self
        descriptionTextView.delegate = self
        collectionView.dataSource = self
        imageShooter.delegate = self
        
        fStoreManager.updateItemDelegate = self
        fStoreManager.uploadItemDelegate = self
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
            $0.left.equalTo(selectPhotoBtn.snp.right).inset(-3)
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


// MARK: - UITextViewDelegate
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


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.images.append(image)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.selectPhotoBtn.setTitle("\(self.images.count)/5", for: .normal)
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension CreateItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.itemCellID, for: indexPath) as? ItemImageCollectionViewCell else {
            fatalError("Failed to load cell!")
        }
        cell.setupCell(img: self.images[indexPath.row])
        cell.btnEvent = {
            print("\(indexPath.row)th image")
            self.images.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.selectPhotoBtn.setTitle("\(self.images.count)/5", for: .normal)
            }
        }
        return cell
    }
    
}


// MARK: - FirestoreManagerItemUpdateDelegate
extension CreateItemViewController: FirestoreManagerItemUpdateDelegate {
    
    func updateItemSuccessed(_ updatedItem: Item) {
        
        print("CreateItemViewController: updateItemSuccessed")
        
        // 이전 화면으로 데이터 넘기기
        let endIndex = naviStack!.endIndex
        let prevVC = naviStack![endIndex-1] as! ItemDetailViewController
        prevVC.itemFromCreateItemVC = updatedItem
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
}

// MARK: - FirestoreManagerUploadItemDelegate
extension CreateItemViewController: FirestoreManagerUploadItemDelegate {
    
    func uploadItemSuccessed() {
        
        print("CreateItemViewController: uploadItemSuccessed")
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
}

