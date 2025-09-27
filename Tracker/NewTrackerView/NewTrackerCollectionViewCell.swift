//
//  NewTrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Сергей Лебедь on 27.08.2025.
//

import UIKit

final class NewTrackerCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "NewTrackerCollectionViewCell"
     lazy var titleLabel = UILabel()
    lazy var activeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private func setupUI() {
        activeImageView.isHidden = true
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.text = ""
        titleLabel.layer.masksToBounds = true
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 8
        contentView.addSubview(activeImageView)
        contentView.addSubview(titleLabel)
        activeImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            activeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
           
        ])
    }
    func  setCompleted(_ color: UIColor) {
        let activeImage = UIImage(resource: .imageActive)
        let coloredImage = activeImage.withTintColor(color, renderingMode: .alwaysOriginal)
        activeImageView.image = coloredImage
        activeImageView.isHidden = false
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        titleLabel.layer.cornerRadius = 8
        titleLabel.backgroundColor = .clear
        activeImageView.isHidden = true
        backgroundColor = .clear
    }
}

