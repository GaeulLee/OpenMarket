//
//  FindPWViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct FindPWViewController_Preview: PreviewProvider {
    static var previews: some View {
        FindPWViewController().toPreview()
    }
}
#endif

class FindPWViewController: UIViewController {
    
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
    
    private let idTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "아이디 입력", attributes: [.foregroundColor: UIColor.lightGray])
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
        btn.setTitle("비밀번호 찾기", for: .normal)
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
    
    
    
    // MARK: - objc
    @objc private func findBtnTapped() {
        if nameTextfield.text != "", emailTextfield.text != "", idTextfield.text != "" {
            fStoreManager.findPW(name: nameTextfield.text!, email: emailTextfield.text!, id: idTextfield.text!)
        }
    }
    
    
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

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    

    // MARK: - private
    private func setUI() {
        self.view.backgroundColor = .backColor
        self.title = "비밃번호 찾기"
        
        fStoreManager.findMemeberPWDelegate = self
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(nameTextfield)
        entireStackView.addArrangedSubview(idTextfield)
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
        
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        findBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
            make.height.equalTo(48)
        }
    }

}

extension FindPWViewController: FirestoreManagerFindMemberPWDelegate {
    
    func findPWSuccessed(_ id: String) {
        let alert = UIAlertController(title: "새 비밀번호 설정", message: "입력하신 정보로 가입된 계정의 비밀번호를 변경합니다. 변경할 새 비밀번호를 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { tf1 in
            tf1.placeholder = "변경할 비밀번호 입력"
            tf1.isSecureTextEntry = true
        }
        
        alert.addTextField { tf2 in
            tf2.placeholder = "비밀번호 확인"
            tf2.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { ok in
            if let tf1 = alert.textFields?[0].text, let tf2 = alert.textFields?[1].text {
                if tf1 != "", tf2 != "" {
                    if tf1 == tf2 {
                        self.fStoreManager.updateMemberPW(with: id, to: tf1)
                        
                        let successAlert = UIAlertController(title: "변경 완료", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(successAlert, animated: true)
                    } else {
                        let errorAlert = UIAlertController(title: "입력 확인", message: "입력한 두 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(errorAlert, animated: true)
                    }
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func findPWFailed() {
        let alert = UIAlertController(title: "비밇번호 찾기 결과", message: "입력하신 정보로 가입된 계정 정보가 존재하지 않습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
}
