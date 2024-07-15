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
    lazy var idTextfield: UITextField = {
        let tf = UITextField()
//        let border = CALayer()
//        let width = CGFloat(1)
//        border.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 50)
//        border.frame = CGRect(x: 0, y: tf.frame.size.height, width: <#T##Int#>, height: <#T##Int#>)
        tf.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: tf.frame.size.height-1, width: tf.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        tf.layer.addSublayer(border)
        tf.textAlignment = .left
        tf.textColor = UIColor.white
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
        sv.spacing = 10
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
        
        self.view.addSubview(loginBtn)
    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        pwCheckTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        nameTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        nickNameTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(entireStackView.snp.bottom).inset(-20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(45)
        }
    }

}
