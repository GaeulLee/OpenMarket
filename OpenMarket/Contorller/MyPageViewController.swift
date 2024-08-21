//
//  MyPageViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct IMyPageViewController_Preview: PreviewProvider {
    static var previews: some View {
        MyPageViewController().toPreview()
    }
}
#endif

class MyPageViewController: UIViewController {
    
    // MARK: - property
    // db 연결 전 임시 데이터
    var items: [Item] = [ Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller2", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["sample1", "sample2", "sample3"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller2", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["sample1", "sample2", "sample3"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다. \n 좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller2", itemImage: ["AppIconImage", "AppIconImage"]), Item(itemName: "first", itemPrice: "100,000원", description: "좋은 물건 아주 싸게 팔아봅니다.", date: "2024-07-24", memberID: "seller1", itemImage: ["sample1", "sample2", "sample3"])]
    
    var fStoreManager = FirestoreManager.shared
    
    // MARK: - UI element
    private let nameLabel1: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let nameLabel2: UILabel = {
        let label = UILabel()
        label.text = "이름 테스트"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let nicknameLabel1: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let nicknameLabel2: UILabel = {
        let label = UILabel()
        label.text = "닉네임 테스트"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    private let changeNicknameBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("변경", for: .normal)
        btn.setTitleColor(.systemBackground, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        btn.backgroundColor = .btnColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 7
        btn.addTarget(self, action: #selector(changeNicknameBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let changePWBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("비밀번호 변경", for: .normal)
        btn.setTitleColor(.defaultFontColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        btn.addTarget(self, action: #selector(changePWTapped), for: .touchUpInside)
        return btn
    }()
    
    private let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("로그아웃", for: .normal)
        btn.setTitleColor(.defaultFontColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        btn.addTarget(self, action: #selector(logOutBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let signoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원탈퇴", for: .normal)
        btn.setTitleColor(.defaultFontColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        btn.addTarget(self, action: #selector(signoutBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    private let tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내가 작성한 게시글"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .backColor
        return tv
    }()
    
    private let topUIView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.tfColor
        return view
    }()
    
    private let leftStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 5
        return sv
    }()
    
    private let rightStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 5
        return sv
    }()
    
    private let btnsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
    
    private let entireUIVeiw: UIView = {
        let view = UIView()
        view.backgroundColor = .backColor
        return view
    }()
    
    
    
    // MARK: - objc
    @objc private func changeNicknameBtnTapped() {
        print("changeNicknameBtnTapped")
    }
    
    @objc private func changePWTapped() {
        print("changePWTapped")
    }
    
    @objc private func logOutBtnTapped() {
        print("logOutBtnTapped")
        dismiss(animated: true)
    }
    
    @objc private func signoutBtnTapped() {
        print("signoutBtnTapped")
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTabelView()
        setNavigationBar()
        setAddSubview()
        setConstraints()
        
        test()
    }
    
    
    // MARK: - private
    
    func test() {
        let member = fStoreManager.getMemberInfo()
        
        nameLabel2.text = member.memberName
        nicknameLabel2.text = member.memberNickname
    }
    
    
    private func setUI() {
        self.title = "My Page"
        self.view.backgroundColor = .backColor
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .defaultFontColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    
    private func setTabelView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: K.tableViewCellID)
        tableView.rowHeight = 100
    }
    
    private func setAddSubview() {
        self.view.addSubview(entireUIVeiw)
        
        leftStackView.addArrangedSubview(nameLabel1)
        leftStackView.addArrangedSubview(nicknameLabel1)
        
        rightStackView.addArrangedSubview(nameLabel2)
        rightStackView.addArrangedSubview(nicknameLabel2)

        topUIView.addSubview(leftStackView)
        topUIView.addSubview(rightStackView)
        topUIView.addSubview(changeNicknameBtn)
        
        btnsStackView.addArrangedSubview(changePWBtn)
        btnsStackView.addArrangedSubview(logoutBtn)
        btnsStackView.addArrangedSubview(signoutBtn)
        
        entireUIVeiw.addSubview(topUIView)
        entireUIVeiw.addSubview(btnsStackView)
        entireUIVeiw.addSubview(tableViewTitleLabel)
        entireUIVeiw.addSubview(tableView)

    }
    
    private func setConstraints() {
        entireUIVeiw.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        topUIView.snp.makeConstraints {
            $0.top.equalTo(entireUIVeiw.snp.top)
            $0.height.equalTo(120)
            $0.width.equalTo(entireUIVeiw.snp.width)
        }
        leftStackView.snp.makeConstraints {
            $0.top.equalTo(topUIView.snp.top)
            $0.left.equalTo(topUIView.snp.left).inset(20)
            $0.height.equalTo(topUIView.snp.height)
        }
        rightStackView.snp.makeConstraints {
            $0.top.equalTo(topUIView.snp.top)
            $0.left.equalTo(leftStackView.snp.right).inset(-20)
            $0.height.equalTo(topUIView.snp.height)
        }
        changeNicknameBtn.snp.makeConstraints {
            $0.right.equalTo(topUIView.snp.right).inset(13)
            $0.bottom.equalTo(topUIView.snp.bottom).inset(13)
            $0.width.equalTo(55)
        }
        
        
        btnsStackView.snp.makeConstraints {
            $0.top.equalTo(topUIView.snp.bottom).inset(-5)
            $0.height.equalTo(30)
            $0.width.equalTo(entireUIVeiw.snp.width)
        }
        
        tableViewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(btnsStackView.snp.bottom).inset(-25)
            $0.width.equalTo(entireUIVeiw.snp.width)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tableViewTitleLabel.snp.bottom).inset(-10)
            $0.width.equalTo(entireUIVeiw.snp.width)
            $0.bottom.equalTo(entireUIVeiw.snp.bottom)
        }
    }

}

// MARK: - UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCellID, for: indexPath) as! ItemTableViewCell
        cell.item = items[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt data -> \(items[indexPath.row].itemName)")
        let vc = ItemDetailViewController()
        vc.item = items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

