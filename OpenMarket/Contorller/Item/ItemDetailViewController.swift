//
//  ItemDetailViewController.swift
//  OpenMarket
//
//  Created by 이가을 on 7/9/24.
//

import UIKit
import SnapKit

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct ItemDetailViewController_Preview: PreviewProvider {
    static var previews: some View {
        ItemDetailViewController().toPreview()
    }
}
#endif


class ItemDetailViewController: UIViewController {
    
    var item: String? {
        didSet {
            pNameLabel.text = item
        }
    }
    
    private var pNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddSubview()
        setConstraints()
    }
    
    private func setUI() {
        //self.title = item!
        self.title = "item"
        self.view.backgroundColor = .systemBackground
    }

    private func setAddSubview() {
        self.view.addSubview(pNameLabel)

    }
    
    private func setConstraints() {
        pNameLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }

}
