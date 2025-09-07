//
//  NewTrackerCollectionSectionHeader.swift
//  Tracker
//
//  Created by Сергей Лебедь on 27.08.2025.
//

import UIKit

final class NewTrackerCollectionSectionHeader: UICollectionReusableView {
    
    static let headerIdentifier = "NewTrackerCollectionSectionHeader"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.text = ""
        titleLabel.textColor = UIColor(resource: .ypBlack)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
