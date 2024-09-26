//
//  FindIDViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct FindIDViewController_Preview: PreviewProvider {
    static var previews: some View {
        FindIDViewController().toPreview()
    }
}
#endif

class FindIDViewController: UIViewController {

    // MARK: - property
    var fStoreManager = FirestoreManager.shared

    
    // MARK: - UI Components
    private let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "이름 입력", attributes: [.foregroundColor: UIColor.lightGray])
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
    
    private let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "이메일 입력", attributes: [.foregroundColor: UIColor.lightGray])
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
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let findBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("아이디 찾기", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(findBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let entireStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Nonitificatoin
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            findBtn.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardSize.height - 20)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        findBtn.snp.updateConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - objc
    @objc private func findBtnTapped() {
        if nameTextfield.text != "", emailTextfield.text != "" {
            fStoreManager.findID(name: nameTextfield.text!, email: emailTextfield.text!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    

    // MARK: - private
    private func setUI() {
        self.view.backgroundColor = .backColor
        self.title = "ID 찾기"
        
        fStoreManager.findMemeberIDDelegate = self
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(nameTextfield)
        entireStackView.addArrangedSubview(emailTextfield)

        self.view.addSubview(findBtn)
    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        nameTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        findBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(48)
        }
    }
}

extension FindIDViewController: FirestoreManagerFindMemberIDDelegate {
    
    func findIDFailed() {
        let alert = UIAlertController(title: "아이디 찾기 결과", message: "입력하신 정보로 가입된 아이디가 존재하지 않습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    
    func findIDSuccessed(_ id: String) {
        let alert = UIAlertController(title: "아이디 찾기 결과", message: "입력하신 정보로 가입된 아이디는 '\(id)' 입니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}
