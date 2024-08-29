//
//  ReminderCell.swift
//  MC3
//
//  Created by Hansen Yudistira on 16/08/24.
//

import UIKit
import MapKit

class ReminderCell: UITableViewCell {
    
    static let identifier = "ReminderCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let coloredLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "balloon.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(systemName: "location.fill")
        locationIcon.tintColor = .systemGray
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let timeIcon = UIImageView()
        timeIcon.image = UIImage(systemName: "clock.fill")
        timeIcon.tintColor = .systemGray
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let locationStack = UIStackView()
        locationStack.axis = .horizontal
        locationStack.spacing = 8
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        let timeStack = UIStackView()
        timeStack.axis = .horizontal
        timeStack.spacing = 8
        timeStack.addArrangedSubview(timeIcon)
        timeStack.addArrangedSubview(timeLabel)
        
        coloredLine.addSubview(symbolImageView)
        containerView.addSubview(coloredLine)
        containerView.addSubview(titleLabel)
        containerView.addSubview(locationStack)
        containerView.addSubview(timeStack)
        contentView.addSubview(containerView)
        contentView.backgroundColor = .secondarySystemBackground
        
        
        coloredLine.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, width: 40)
        NSLayoutConstraint.activate([
            symbolImageView.centerXAnchor.constraint(equalTo: coloredLine.centerXAnchor),
            symbolImageView.centerYAnchor.constraint(equalTo: coloredLine.centerYAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: 24),
            symbolImageView.widthAnchor.constraint(equalToConstant: 24),
        ])
        titleLabel.anchor(top: containerView.topAnchor, leading: coloredLine.trailingAnchor, paddingTop: 12, paddingLeading: 16)
        
        locationStack.anchor(top: titleLabel.bottomAnchor, leading: titleLabel.leadingAnchor, paddingTop: 4, height: 20)
        
        timeStack.anchor(top: locationStack.bottomAnchor, leading: locationStack.leadingAnchor, bottom: containerView.bottomAnchor, paddingTop: 4, paddingBottom: 12)
        
        containerView.anchor(top: contentView.topAnchor, leading:  contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, paddingTop: 8, paddingLeading: 16, paddingBottom: 8, paddingTrailing: 16)
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    func configure(with reminder: Reminder) {
        titleLabel.text = reminder.title
        
        if reminder.locationSwitch {
            locationLabel.text = reminder.placeMark
        } else {
            locationLabel.text = "-"
        }
        
        if reminder.timeSwitch, let time = reminder.time  {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = dateFormatter.string(from: time)
        } else {
            timeLabel.text = "-"
        }
        let colorName = reminder.colorTag
        if  colorName != "" {
            coloredLine.backgroundColor = color(from: colorName)
        } else {
            coloredLine.backgroundColor = .systemGray
        }
        symbolImageView.image = UIImage(systemName: reminder.symbolTag)
    }
    
    private func color(from colorName: String) -> UIColor {
        switch colorName {
        case "systemCyan":
            return .systemCyan
        case "systemOrange":
            return .systemOrange
        case "systemBrown":
            return .systemBrown
        case "systemBlue":
            return .systemBlue
        default:
            return .systemGray
        }
    }
}
