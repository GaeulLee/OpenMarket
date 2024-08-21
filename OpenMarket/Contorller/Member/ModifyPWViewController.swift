//
//  ModifyPWViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ModifyPWViewController_Preview: PreviewProvider {
    static var previews: some View {
        ModifyPWViewController().toPreview()
    }
}
#endif

class ModifyPWViewController: UIViewController {

    // MARK: - UI Components
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
    
    private let modifyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("비밀번호 수정", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(modifyBtnTapped), for: .touchUpInside)
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
    @objc private func modifyBtnTapped() {
        print("modifyBtnTapped")
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setStackView()
        setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    

    // MARK: - private
    private func setUI() {
        self.view.backgroundColor = .backColor
        self.title = "비밀번호 수정"
    }

    private func setStackView() {
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(pwTextfield)
        entireStackView.addArrangedSubview(pwCheckTextfield)

        self.view.addSubview(modifyBtn)
    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
        }
        
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        pwCheckTextfield.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        modifyBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.top.equalTo(entireStackView.snp.bottom).inset(-20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(48)
        }
    }


}
