//
//  MyPageViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit

class MyPageViewController: UIViewController {

    private var logOutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOGIN", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(logOutBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc private func logOutBtnTapped() {
        print("logOutBtnTapped")

        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
    }
    
    private func setUI() {
        self.title = "My Page"
        self.view.backgroundColor = .systemBackground
    }

    private func setAddSubview() {
        self.view.addSubview(logOutBtn)

    }
    
    private func setConstraints() {
        logOutBtn.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }


}
