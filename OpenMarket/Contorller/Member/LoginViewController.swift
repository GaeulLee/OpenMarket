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
    
    // ID
    private let idTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfColor
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()

    private var idLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter ID"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let idTextfield: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none // 첫글자 대문자 설정 X
        tf.autocorrectionType = .no // 자동 수정 설정 X
        tf.spellCheckingType = .no // 맞춤법 검사 설정 X
        return tf
    }()
    

    // PW
    private let pwTextfieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tfColor
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    private var pwLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Password"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let pwTextfield: UITextField = {
        var tf = UITextField()
        tf.backgroundColor = .clear
        tf.textColor = .lightGray
        tf.tintColor = .lightGray
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let pwShowBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        btn.addTarget(self, action: #selector(pwShowModeSetting), for: .touchUpInside)
        return btn
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOGIN", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let findIDBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("ID 찾기", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(findIDBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let findPWBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" PW 찾기", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(findPWBtnTapped), for: .touchUpInside)
        return btn
    }()

    private let divideLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let signInBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원가입", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.addTarget(self, action: #selector(signInBtnTapped), for: .touchUpInside)
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
    
    private let bottomLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: - objc
    @objc func pwShowModeSetting() {
        pwTextfield.isSecureTextEntry.toggle()
    }
    
    @objc func loginBtnTapped() {
        print("loginBtn clicked")
        
        // 탭바컨트롤러 생성
        let tabBarVC = UITabBarController()
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: MyPageViewController())
        
        // 탭바 이름들 설정
        vc1.title = "Home"
        vc2.title = "My page"
        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBarVC.tabBar.backgroundColor = .backColor
        tabBarVC.tabBar.tintColor = .btnColor
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.tabBar.scrollEdgeAppearance = appearance
        
        // 탭바 이미지 설정
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house.fill")
        items[1].image = UIImage(systemName: "person.fill")
        
        // 프리젠트로 탭바를 띄우기
        present(tabBarVC, animated: true, completion: nil)
    }
    
    @objc func findIDBtnTapped() {
        print("findIDBtn clicked")
        let vc = FindIDViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func findPWBtnTapped() {
        print("findPWBtn clicked")
        let vc = FindPWViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signInBtnTapped() {
        print("signInBtn clicked")
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
        setAddSubview()
        setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    // MARK: - private
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .backColor
        
        idTextfield.delegate = self
        pwTextfield.delegate = self
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .defaultFontColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setAddSubview() {
        idTextfieldView.addSubview(idLabel)
        idTextfieldView.addSubview(idTextfield)
        
        pwTextfieldView.addSubview(pwLabel)
        pwTextfieldView.addSubview(pwTextfield)
        pwTextfieldView.addSubview(pwShowBtn)
        
        bottomLineView.addSubview(findIDBtn)
        bottomLineView.addSubview(divideLabel)
        bottomLineView.addSubview(findPWBtn)
        bottomLineView.addSubview(signInBtn)
        
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(idTextfieldView)
        entireStackView.addArrangedSubview(pwTextfieldView)
        entireStackView.addArrangedSubview(loginBtn)
        entireStackView.addArrangedSubview(bottomLineView)
    }
    
    private func setConstraints() {
        // stackView
        entireStackView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(50)
        }
        
        // id
        idTextfield.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.left.equalTo(idTextfieldView.snp.left).inset(8)
            make.right.equalTo(idTextfieldView.snp.right).inset(8)
            make.top.equalTo(idTextfieldView.snp.top).inset(15)
            make.bottom.equalTo(idTextfieldView.snp.bottom).inset(2)
        }
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(idTextfield.snp.left)
            make.right.equalTo(idTextfield.snp.right)
            make.top.equalTo(idTextfield.snp.top)
        }
        
        // pw
        pwTextfield.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.left.equalTo(pwTextfieldView.snp.left).inset(8)
            make.right.equalTo(pwTextfieldView.snp.right).inset(8)
            make.top.equalTo(pwTextfieldView.snp.top).inset(15)
            make.bottom.equalTo(pwTextfieldView.snp.bottom).inset(2)
        }
        pwLabel.snp.makeConstraints { make in
            make.left.equalTo(pwTextfield.snp.left)
            make.right.equalTo(pwTextfield.snp.right)
            make.top.equalTo(pwTextfield.snp.top)
        }
        pwShowBtn.snp.makeConstraints { make in
            make.right.equalTo(pwTextfield.snp.right)
            make.top.equalTo(pwTextfield.snp.top).inset(-4)
        }
        
        
        // loginBtn
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        
        // bottomLineView
        bottomLineView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        findIDBtn.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.left.equalTo(bottomLineView.snp.left)
        }
        divideLabel.snp.makeConstraints { make in
            make.width.equalTo(5)
            make.left.equalTo(findIDBtn.snp.right).inset(3)
            make.top.equalTo(bottomLineView.snp.top).inset(5)
        }
        findPWBtn.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.left.equalTo(divideLabel.snp.right)
        }
        signInBtn.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.right.equalTo(bottomLineView.snp.right).inset(4)
        }
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.idTextfield {
            self.idLabel.snp.updateConstraints { make in
                make.top.equalTo(textField.snp.top).inset(-12)
            }
            UIView.animate(withDuration: 0.3) {
                self.idLabel.font = .systemFont(ofSize: 14, weight: .bold)
                self.idLabel.superview?.layoutIfNeeded()
            }
        }
        
        if textField == self.pwTextfield {
            self.pwLabel.snp.updateConstraints { make in
                make.top.equalTo(textField).offset(-12)
            }
            UIView.animate(withDuration: 0.3) {
                self.pwLabel.font = .systemFont(ofSize: 14, weight: .bold)
                self.pwLabel.superview?.layoutIfNeeded()
            }
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.idTextfield && textField.text == "" {
            self.idLabel.snp.updateConstraints { make in
                make.top.equalTo(textField.snp.top)
            }
            UIView.animate(withDuration: 0.3) {
                self.idLabel.font = .systemFont(ofSize: 16, weight: .bold)
                self.idLabel.superview?.layoutIfNeeded()
            }
        }
        
        if textField == self.pwTextfield  && textField.text == "" {
            self.pwLabel.snp.updateConstraints { make in
                make.top.equalTo(textField.snp.top)
            }
            UIView.animate(withDuration: 0.3) {
                self.pwLabel.font = .systemFont(ofSize: 16, weight: .bold)
                self.pwLabel.superview?.layoutIfNeeded()
            }
        }
        
    }
}
