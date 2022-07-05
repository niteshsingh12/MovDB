//
//  CollectionLayoutHeader.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let reuseIdentifier = "header-reuse-identifier"
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    var padding: CGFloat = 10
    
    // MARK: - Initialization
    
    ///Configures header view and activates constraints
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Extension Configure

extension HeaderView {
    
    func configure(padding: CGFloat, font: UIFont) {
        
        headerLabel.font = font
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
}
