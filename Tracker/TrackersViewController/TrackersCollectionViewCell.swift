//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Сергей Лебедь on 03.08.2025.
//

import UIKit
protocol TrackersCollectionViewCellDelegate: AnyObject {
    func updateCompletedTrackers(_ cell: TrackersCollectionViewCell)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "TrackerCollectionViewCell"
    lazy var trackerLabel = UILabel()
    lazy var emojiLabel = UILabel()
    lazy var nameLabel = UILabel()
    private lazy var managementLabel = UILabel()
    lazy var dayCountLabel = UILabel()
    var dayCount: Int = 0
    let button = UIButton()
    weak var delegate : TrackersCollectionViewCellDelegate?
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(trackerLabel)
        contentView.addSubview(managementLabel)
        trackerLabel.addSubview(emojiLabel)
        trackerLabel.addSubview(nameLabel)
        managementLabel.addSubview(dayCountLabel)
        managementLabel.addSubview(button)
        
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        managementLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        dayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupConstraints() {
        addSubviews()
        NSLayoutConstraint.activate([
            trackerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerLabel.heightAnchor.constraint (equalToConstant: 90),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerLabel.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: trackerLabel.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: trackerLabel.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trackerLabel.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: -12),
            managementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            managementLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            managementLabel.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor),
            managementLabel.heightAnchor.constraint (equalToConstant: 58),
            managementLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 34),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.topAnchor.constraint(equalTo: managementLabel.topAnchor, constant: 8 ),
            button.trailingAnchor.constraint(equalTo: managementLabel.trailingAnchor, constant: -12),
            dayCountLabel.leadingAnchor.constraint(equalTo: managementLabel.leadingAnchor, constant: 12),
            dayCountLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            dayCountLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8)
        ])
    }
    func dayString(for count: Int) {
        let formattedString: String
           switch (count % 10, count % 100) {
           case (1, let r100) where r100 != 11:
               formattedString = "\(count) день"
           case (2...4, let r100) where !(12...14).contains(r100):
               formattedString = "\(count) дня"
           default:
               formattedString = "\(count) дней"
           }
           dayCountLabel.text = formattedString
       }
    
    private func setupUI() {
        contentView.isUserInteractionEnabled = true
        managementLabel.isUserInteractionEnabled = true
        button.isUserInteractionEnabled = true
        trackerLabel.layer.cornerRadius = 12
        trackerLabel.clipsToBounds = true
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dayCountLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dayCountLabel.text = "0 деней"
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    func  setCompleted(_ isCompletedToday: Bool, color: UIColor) {
        let plusCompletedImage = UIImage(resource: .plusCompleted)
        let completedImage = UIImage(resource: .completed)
        let coloredPlusCompletedImage = plusCompletedImage.withTintColor(color, renderingMode: .alwaysOriginal)
        let coloredImage = completedImage.withTintColor(color, renderingMode: .alwaysOriginal)
        if !isCompletedToday {
            button.setImage(coloredPlusCompletedImage, for: .normal)
        } else {
            button.setImage(coloredImage, for: .normal)
        }
    }
    
    @objc private func didTapCompleteButton() {
        delegate?.updateCompletedTrackers(self)
    }
    
}

