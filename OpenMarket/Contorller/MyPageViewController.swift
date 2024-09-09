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
    var items: [Item] = []
    var fStoreManager = FirestoreManager.shared
    
    // MARK: - UI element
    lazy var optionButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionButtonTapped))
        return button
    }()
    
    private let nameLabel1: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let nameLabel2: UILabel = {
        let label = UILabel()
        label.text = "이름 테스트"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let nicknameLabel1: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .defaultFontColor
        return label
    }()
    
    private let nicknameLabel2: UILabel = {
        let label = UILabel()
        label.text = "닉네임 테스트"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .defaultFontColor
        return label
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
    @objc private func optionButtonTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 닉네임 변경
        sheet.addAction(UIAlertAction(title: "닉네임 변경", style: .default, handler: { action in
            let alert = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
            
            alert.addTextField { tf in
                tf.placeholder = "변경할 닉네임 입력"
            }
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { ok in
                if let nickname = alert.textFields?[0].text {
                    if nickname != "" {
                        let id = self.fStoreManager.getMemberInfo().memberID
                        self.fStoreManager.updateMemberNickname(with: id, to: nickname)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }))
        
        // 비밀번호 변경
        sheet.addAction(UIAlertAction(title: "비밀번호 변경", style: .default, handler: { action in
            let alert = UIAlertController(title: "비밀번호 변경", message: nil, preferredStyle: .alert)
            
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
                            let id = self.fStoreManager.getMemberInfo().memberID
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
        }))
        
        // 탈퇴
        sheet.addAction(UIAlertAction(title: "회원탈퇴", style: .default, handler: { action in
            let confirmAlert = UIAlertController(title: "회원탈퇴", message: "정말 회원을 탈퇴하시겠습니까? 작성한 글은 모두 자동으로 삭제됩니다.", preferredStyle: .alert)

            confirmAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { deleteAction in
                let id = self.fStoreManager.getMemberInfo().memberID
                self.fStoreManager.deleteMember(with: id)
                // 글 삭제
                self.fStoreManager.setMemberInfo(nil)
                self.dismiss(animated: true)
            }))
            confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            self.present(confirmAlert, animated: true)
        }))
        
        // 로그아웃
        sheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { action in
            self.fStoreManager.setMemberInfo(nil)
            self.dismiss(animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(sheet, animated: true)
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTabelView()
        setNavigationBar()
        setAddSubview()
        setConstraints()
        
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    // MARK: - private
    
    func setData() {
        let member = fStoreManager.getMemberInfo()
        
        fStoreManager.readOneMembersItems(with: member.memberID)
        
        nameLabel2.text = member.memberName
        nicknameLabel2.text = member.memberNickname
    }
    
    
    private func setUI() {
        self.title = "My Page"
        self.view.backgroundColor = .backColor
        
        fStoreManager.memberInfoDelegate = self
        fStoreManager.itemDelegate = self
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .defaultFontColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.rightBarButtonItem = self.optionButton
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

        entireUIVeiw.addSubview(topUIView)
        entireUIVeiw.addSubview(tableViewTitleLabel)
        entireUIVeiw.addSubview(tableView)

    }
    
    private func setConstraints() {
        entireUIVeiw.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(0)
        }
        
        topUIView.snp.makeConstraints {
            $0.top.equalTo(entireUIVeiw.snp.top)
            $0.height.equalTo(120)
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(5)

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
        
        tableViewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topUIView.snp.bottom).inset(-25)
            $0.left.equalTo(self.view.safeAreaLayoutGuide).inset(5)
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

// MARK: - FirestoreManagerMemberInfoDelegate
extension MyPageViewController: FirestoreManagerMemberInfoDelegate {
    
    func changeMemberInfoSuccessed() {
        setData()
    }
    
}

// MARK: - FirestoreManagerItemDelegate
extension MyPageViewController: FirestoreManagerItemReadDelegate {
    
    func readAllItemSuccessed(_ items: [Item]) {
        print("")
    }
    
    func readOneMembersItemSuccessed(_ items: [Item]) {
        self.items = items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}


