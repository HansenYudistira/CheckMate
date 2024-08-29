//
//  TimePickerView.swift
//  MC3
//
//  Created by Hansen Yudistira on 19/08/24.
//

import UIKit

class TimePickerView: UIView {
    private var dayButtons: [UIButton] = []
    let timePicker = UIDatePicker()
    let daysStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        translatesAutoresizingMaskIntoConstraints = false

        let timeImage = UIImage(systemName: "clock")
        let timeImageView = UIImageView(image: timeImage)
        timeImageView.contentMode = .scaleAspectFit
        timeImageView.tintColor = UIColor(named: "BlackColor")
        
        timePicker.datePickerMode = .time
        timePicker.translatesAutoresizingMaskIntoConstraints = false

        let timePickerStackView = UIStackView(arrangedSubviews: [timeImageView, timePicker])
        timePickerStackView.axis = .horizontal
        timePickerStackView.spacing = 10
        timePickerStackView.alignment = .center
        
        let repeatLabel = UILabel()
        repeatLabel.text = "Repeat"
        repeatLabel.font = UIFont.systemFont(ofSize: 16)
        
        daysStackView.axis = .horizontal
        daysStackView.distribution = .equalSpacing
        daysStackView.spacing = 5

        let days: [(shortTitle: String, weekday: Int)] = [
            ("M", 2),
            ("T", 3),
            ("W", 4),
            ("T", 5),
            ("F", 6),
            ("S", 7),
            ("S", 1)
        ]
        
        for (_, value) in days.enumerated() {
            let button = createDayButton(title: value.shortTitle, weekday: value.weekday)
            dayButtons.append(button)
            daysStackView.addArrangedSubview(button)
        }

        addSubview(timePickerStackView)
        addSubview(repeatLabel)
        addSubview(daysStackView)
        
        timePickerStackView.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 10, paddingLeading: 10, height: 50)
        
        repeatLabel.anchor(top: timePicker.bottomAnchor, leading: leadingAnchor, paddingTop: 10, paddingLeading: 10)
        
        daysStackView.anchor(top: repeatLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 10, paddingLeading: 10, paddingBottom: 10, paddingTrailing: 10)
    }
    
    private func createDayButton(title: String, weekday: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(dayButtonTapped(_ :)), for: .touchUpInside)
        button.tag = weekday
        return button
    }
    
    func configure(with reminder: Reminder) {
        if let time = reminder.time {
            timePicker.setDate(time, animated: true)
        }

        for button in dayButtons {
            button.isSelected = reminder.days?.contains(button.tag) ?? false
            if button.isSelected {
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .selected)
                button.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.systemGray, for: .normal)
                button.layer.borderColor = UIColor.systemGray.cgColor
            }
        }
    }

    @objc private func dayButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .systemBlue
            sender.setTitleColor(.white, for: .selected)
            sender.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            sender.backgroundColor = .clear
            sender.setTitleColor(.systemGray, for: .normal)
            sender.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
}
