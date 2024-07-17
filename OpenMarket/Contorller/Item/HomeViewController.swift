//
//  HomeViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct HomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview()
    }
}
#endif


class HomeViewController: UIViewController {

    // MARK: - UI elements
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
    private let tableView = UITableView()
    
    
    // MARK: - property
    var items: [String] = [ "one", "two", "three" ]

    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setNavigationBar()
        setConstraints()
    }
    
    
    // MARK: - objc
    @objc private func plusButtonTapped() {
        print("plusButtonTapped")
        let vc = CreateItemViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - private
    
    private func setUI() {
        self.title = ""
        self.view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        
        self.view.addSubview(tableView)
        tableView.rowHeight = 100
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .defaultFontColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ItemTableViewCell
        
        cell.item = items[indexPath.row]
        return cell
    }
    
}
