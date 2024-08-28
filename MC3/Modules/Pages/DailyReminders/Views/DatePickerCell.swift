//
//  DatePickerCell.swift
//  MC3
//
//  Created by Hansen Yudistira on 22/08/24.
//

import UIKit

class DatePickerCell: UICollectionViewCell {
    static let identifier = "DatePickerCell"
    
    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        dayLabel.textAlignment = .center
        dayLabel.textColor = .systemGray
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        dateLabel.textAlignment = .center
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.layer.cornerRadius = 16
        dateLabel.layer.masksToBounds = true
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(dateLabel)
        
        dayLabel.anchor(top: contentView.topAnchor)
        dateLabel.anchor(top: dayLabel.bottomAnchor, paddingTop: 4, width: 32, height: 32)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 32),
            dateLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with dateModel: DateModel, isSelected: Bool) {
        dayLabel.text = dateModel.dayName
        dateLabel.text = dateModel.date
        
        if isSelected {
            dateLabel.backgroundColor = .systemTeal
            dateLabel.textColor = .white
        } else {
            dateLabel.backgroundColor = .clear
            dateLabel.textColor = .systemGray
        }
    }
}
