//
//  SignInViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct SignInViewController_Preview: PreviewProvider {
    static var previews: some View {
        SignUpViewController().toPreview()
    }
}
#endif

class SignUpViewController: UIViewController {

    // MARK: - Property
    var fStoreManager = FirestoreManager.shared

    // MARK: - UI Components
    private let idTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter ID"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none // 첫글자 대문자 설정 X
        tf.autocorrectionType = .no // 자동 수정 설정 X
        tf.spellCheckingType = .no // 맞춤법 검사 설정 X
        return tf
    }()
    
    private let pwTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Password"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let pwCheckTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Check Password"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Name"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let nickNameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Nickname"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .tfColor
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let joinBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("JOIN", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(joinBtnTapped), for: .touchUpInside)
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
    @objc private func joinBtnTapped() {
        print("joinBtnTapped")
        var member = Member(memberID: "abc", memberPW: "123", memberName: "test", memberNickname: "test123", memberEmail: "email")
        fStoreManager.createMember(member) // success
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setConstraints()
    }

    
    // MARK: - private
    private func setUI() {
        self.view.backgroundColor = .systemBackground
        self.title = "회원가입"
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(idTextfield)
        entireStackView.addArrangedSubview(emailTextfield)
        entireStackView.addArrangedSubview(pwTextfield)
        entireStackView.addArrangedSubview(pwCheckTextfield)
        entireStackView.addArrangedSubview(nameTextfield)
        entireStackView.addArrangedSubview(nickNameTextfield)

        
        self.view.addSubview(joinBtn)
    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        pwCheckTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        nameTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        nickNameTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        joinBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(entireStackView.snp.bottom).inset(-20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(48)
        }
    }

}
