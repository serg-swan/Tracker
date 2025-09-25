//
//  NewCategoryTableViewCell.swift
//  Tracker
//
//  Created by Сергей Лебедь on 21.09.2025.
//

import UIKit

final class NewCategoryTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "NewCategoryTableViewCell"
    lazy var titleLabel = UILabel()
    lazy var separator = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.text = ""
        titleLabel.textColor = UIColor(resource: .ypBlack)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27)
        ])

        separator.backgroundColor = UIColor(resource: .ypGray)
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        separator.isHidden = false
    backgroundColor = UIColor(resource: .ypBackground)
    titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    layer.cornerRadius = 16
    layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
