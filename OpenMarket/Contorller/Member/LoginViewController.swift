//
//  ViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/8/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct LoginViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
#endif

class LoginViewController: UIViewController {
    
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
    
    let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOGIN", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    let findIDBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("ID 찾기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        //btn.backgroundColor = .systemBlue
        return btn
    }()
    
    let divideLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
//        label.font =
        return label
    }()
    
    let findPWBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" PW 찾기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        //btn.backgroundColor = .systemBlue
        return btn
    }()
    
    let signInBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        //btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(showSignInVC), for: .touchUpInside)
        return btn
    }()
    
    @objc func showSignInVC() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let entireStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()
    
    let bottomLineStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 50
        return sv
    }()
    
    let findIDPWBtnStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 1
        return sv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setStackView()
        setConstraints()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
    }
    
    private func setNavigationBar() {
        // 네비게이션 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setStackView() {
        self.view.addSubview(findIDPWBtnStackView)
        findIDPWBtnStackView.addArrangedSubview(findIDBtn)
        findIDPWBtnStackView.addArrangedSubview(divideLabel)
        findIDPWBtnStackView.addArrangedSubview(findPWBtn)
        
        self.view.addSubview(bottomLineStackView)
        bottomLineStackView.addArrangedSubview(findIDPWBtnStackView)
        bottomLineStackView.addArrangedSubview(signInBtn)
        
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(idTextfield)
        entireStackView.addArrangedSubview(pwTextfield)
        entireStackView.addArrangedSubview(loginBtn)
        entireStackView.addArrangedSubview(bottomLineStackView)

    }
    
    private func setConstraints() {
        entireStackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(60)
            make.width.equalTo(70)
        }
        
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(idTextfield.snp.bottom).offset(10)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        divideLabel.snp.makeConstraints { make in
            make.width.equalTo(5)
        }
    }
}
