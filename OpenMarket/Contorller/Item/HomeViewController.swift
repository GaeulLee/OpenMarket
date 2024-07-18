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
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["LIST", "GRID"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(scValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    
    private let tableView = UITableView()

    let collectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 250)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: K.collectionViewCellID)
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cv
    }()
    
    
    // MARK: - property
    var items: [String] = [ "one", "two", "three", "two", "three", "two", "three", "two", "three", "two", "three", "two", "three" ]
    
    
    // MARK: - objc
    @objc private func plusButtonTapped() {
        print("plusButtonTapped")
        let vc = CreateItemViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func scValueChanged(_ sender: UISegmentedControl) {
        print("scValueChanged")
        if sender.selectedSegmentIndex == 0 { // tableView
            tableView.isHidden = false
            collectionView.isHidden = true
        } else { // collectionView
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setTableView()
        setupCollectioView()
        setNavigationBar()
        setNavigationTitleView()
        setConstraints()
        
        collectionView.isHidden = true
    }
    

    // MARK: - private

    func setupCollectioView() {
        //  뷰에 추가
        self.view.addSubview(collectionView)
        
        // dataSource 채택
        collectionView.dataSource = self
    }
    
    private func setUI() {
        self.title = "Home"
        self.view.backgroundColor = .systemBackground
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: K.tableViewCellID)
        tableView.rowHeight = 100
        
        self.view.addSubview(tableView)
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .defaultFontColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.rightBarButtonItem = self.plusButton // 네비게이션 오른쪽 상단 버튼 설정
    }
    
    private func setNavigationTitleView() {
        self.navigationItem.titleView = segmentedControl
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt data -> \(items[indexPath.row])")
        let vc = ItemDetailViewController()
        vc.item = items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.tableViewCellID, for: indexPath) as! ItemTableViewCell
        
        cell.item = items[indexPath.row]
        return cell
    }
    
}


extension HomeViewController: UICollectionViewDataSource {

    // cell의 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    // cell에 표현될 뷰를 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 위에서 등록해 둔 withReuseIdentifier를 갖고 cell을 만듭니다.
        // 커스텀 셀을 만들어 사용 시 다운 캐스팅으로 설정한 타입으로 변환 시켜줘서 사용합니다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionViewCellID, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Failed to load cell!")
        }
        cell.setupCell(item: items[indexPath.row])
        return cell
    }
}
