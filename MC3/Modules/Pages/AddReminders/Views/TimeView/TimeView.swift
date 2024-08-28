//
//  TimeView.swift
//  MC3
//
//  Created by Hansen Yudistira on 19/08/24.
//

import UIKit

protocol TimeViewDelegate: AnyObject {
    func timeSwitchToggled(isOn: Bool)
}

class TimeView: UIStackView {
    let timeSwitch = UISwitch()
    
    weak var delegate: TimeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        backgroundColor = .white
        layer.cornerRadius = 10
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = "Set Time"
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeSwitch.translatesAutoresizingMaskIntoConstraints = false
        timeSwitch.addTarget(self, action: #selector(timeSwitchToggled(_ :)), for: .valueChanged)
        
        addArrangedSubview(timeLabel)
        addArrangedSubview(timeSwitch)
        timeLabel.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 8, paddingLeading: 8)
        timeSwitch.anchor(top: topAnchor, trailing: trailingAnchor, paddingTop: 8, paddingTrailing: 8)
    }
    
    @objc private func timeSwitchToggled(_ sender: UISwitch!) {
        delegate?.timeSwitchToggled(isOn: sender.isOn)
    }
}
