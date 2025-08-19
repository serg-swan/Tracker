//
//  TrackersCollectionSectionHeader.swift
//  Tracker
//
//  Created by Сергей Лебедь on 03.08.2025.
//

import UIKit

final class TrackersCollectionSectionHeader: UICollectionReusableView {
  private let titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
                      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
                      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with title: String){
        titleLabel.text = title
    }
    
}
