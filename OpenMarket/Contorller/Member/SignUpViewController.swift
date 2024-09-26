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
    
    var idDuplCheck = false
    var nickDuplCheck = false
    

    // MARK: - UI Components
    private let idTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter ID", attributes: [.foregroundColor: UIColor.lightGray])
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
    
    private let nickNameTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Nickname", attributes: [.foregroundColor: UIColor.lightGray])
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
    
    private let idUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let nickUIView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let idDuplCheckBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("중복 확인", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(idDuplCheckBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let nickDuplCheckBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("중복 확인", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(nickDuplCheckBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let pwTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [.foregroundColor: UIColor.lightGray])
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
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let pwCheckTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Check Password", attributes: [.foregroundColor: UIColor.lightGray])
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
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [.foregroundColor: UIColor.lightGray])
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
        tf.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [.foregroundColor: UIColor.lightGray])
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
        // 유효성 체크 ⭐️
        if !idDuplCheck {
            let alert = UIAlertController(title: "아이디 중복 확인 필요", message: "입력하신 아이디의 중복 확인을 해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
        
        if !nickDuplCheck {
            let alert = UIAlertController(title: "닉네임 중복 확인 필요", message: "입력하신 닉네임의 중복 확인을 해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
        
        if idTextfield.text != "", pwTextfield.text != "", pwCheckTextfield.text != "",
           nameTextfield.text != "", nickNameTextfield.text != "", emailTextfield.text != "",
            idDuplCheck, nickDuplCheck {
            var member = Member(memberID: idTextfield.text!,
                                memberPW: pwTextfield.text!,
                                memberName: nameTextfield.text!,
                                memberNickname: nickNameTextfield.text!,
                                memberEmail: emailTextfield.text!)
            fStoreManager.createMember(member)
        }
    }
    
    @objc private func idDuplCheckBtnTapped() {
        if idTextfield.text != "" {
            fStoreManager.checkDuplication(with: idTextfield.text!, fieldName: K.DB.MemberField.Id)
        }
    }

    @objc private func nickDuplCheckBtnTapped() {
        if nickNameTextfield.text != "" {
            fStoreManager.checkDuplication(with: nickNameTextfield.text!, fieldName: K.DB.MemberField.Nickname)
        }
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    // MARK: - Nonitificatoin
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            joinBtn.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardSize.height - 20)
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(notification: Notification) {
        joinBtn.snp.updateConstraints { make in
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

    
    // MARK: - private
    private func setUI() {
        self.view.backgroundColor = .backColor
        self.title = "회원가입"
        
        fStoreManager.memberSingUpDelegate = self
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        
        idUIView.addSubview(idTextfield)
        idUIView.addSubview(idDuplCheckBtn)
        
        nickUIView.addSubview(nickNameTextfield)
        nickUIView.addSubview(nickDuplCheckBtn)
        
        entireStackView.addArrangedSubview(idUIView)
        entireStackView.addArrangedSubview(nameTextfield)
        entireStackView.addArrangedSubview(nickUIView)
        entireStackView.addArrangedSubview(pwTextfield)
        entireStackView.addArrangedSubview(pwCheckTextfield)
        entireStackView.addArrangedSubview(emailTextfield)
        
        self.view.addSubview(joinBtn)
    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.left.equalTo(idUIView.snp.left).inset(0)
            make.right.equalTo(idUIView.snp.right).inset(0)
            make.height.equalTo(idUIView.snp.height).inset(0)
        }
        
        idDuplCheckBtn.snp.makeConstraints { make in
            make.right.equalTo(idUIView.snp.right).inset(5)
            make.centerY.equalTo(idUIView.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(34)
        }
        
        idUIView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        
        nickNameTextfield.snp.makeConstraints { make in
            make.left.equalTo(nickUIView.snp.left).inset(0)
            make.right.equalTo(nickUIView.snp.right).inset(0)
            make.height.equalTo(nickUIView.snp.height).inset(0)
        }
        
        nickDuplCheckBtn.snp.makeConstraints { make in
            make.right.equalTo(nickUIView.snp.right).inset(5)
            make.centerY.equalTo(nickUIView.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(34)
        }
        
        nickUIView.snp.makeConstraints { make in
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
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        joinBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(0)
            make.height.equalTo(48)
        }
    }

}


// MARK: - FirestoreManagerDelegate
extension SignUpViewController: FirestoreManagerMemberSingUpDelegate {
    
    func ableToProceedSignUp(_ fieldName: String) {
        var fName = ""
        if fieldName == K.DB.MemberField.Id {
            fName = "아이디"
            self.idDuplCheck = true
        } else {
            fName = "닉네임"
            self.nickDuplCheck = true
        }
        
        let alert = UIAlertController(title: "\(fName) 중복 확인", message: "입력하신 \(fName) '\(idTextfield.text!)'는 사용 가능한 \(fName)입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    func disableToProceedSignUp(_ fieldName: String) {
        var fName = "닉네임"
        if fieldName == K.DB.MemberField.Id {
            fName = "아이디"
        }
        
        let alert = UIAlertController(title: "\(fName) 중복 확인", message: "입력하신 \(fName) '\(idTextfield.text!)'는 사용 중인 \(fName)입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    
    func signUpSuccessed() {
        let sheet = UIAlertController(title: "회원가입 성공", message: "회원가입에 성공했습니다. 로그인 화면으로 돌아갑니다.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(sheet, animated: true)
    }
    
}

