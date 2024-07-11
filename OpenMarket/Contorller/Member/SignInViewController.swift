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
        SignInViewController().toPreview()
    }
}
#endif

class SignInViewController: UIViewController {

    // MARK: - UI Components
    let idTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "ID"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    
    let pwTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "PW"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    
    let pwCheckTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "PW Check"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    let nickNameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nickname"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        return tf
    }()
    
    let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("JOIN", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    let entireStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setConstraints()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.title = "Sign In"
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(idTextfield)
        entireStackView.addArrangedSubview(pwTextfield)
        entireStackView.addArrangedSubview(pwCheckTextfield)
        entireStackView.addArrangedSubview(nameTextfield)
        entireStackView.addArrangedSubview(nickNameTextfield)
        entireStackView.addArrangedSubview(emailTextfield)
        entireStackView.addArrangedSubview(loginBtn)

    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(60)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(idTextfield.snp.bottom).offset(10)
        }
        
        pwCheckTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(pwTextfield.snp.bottom).offset(10)
        }
        
        nameTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(pwCheckTextfield.snp.bottom).offset(10)
        }
        
        nickNameTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(nameTextfield.snp.bottom).offset(10)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(nickNameTextfield.snp.bottom).offset(10)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
    }

}
