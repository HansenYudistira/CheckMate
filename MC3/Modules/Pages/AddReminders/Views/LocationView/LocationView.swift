//
//  LocationVIew.swift
//  MC3
//
//  Created by Hansen Yudistira on 19/08/24.
//

import UIKit

protocol LocationViewDelegate: AnyObject {
    func locationSwitchToggled(isOn: Bool)
}

class LocationView: UIStackView {
    let locationSwitch = UISwitch()
    
    weak var delegate: LocationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        translatesAutoresizingMaskIntoConstraints = false
        
        let locationLabel = UILabel()
        locationLabel.text = "Set Location"
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        locationLabel.textColor = UIColor(named: "BlackColor")
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationSwitch.translatesAutoresizingMaskIntoConstraints = false
        locationSwitch.addTarget(self, action: #selector(locationSwitchToggled(_ :)), for: .valueChanged)
        
        addArrangedSubview(locationLabel)
        addArrangedSubview(locationSwitch)
        
        locationLabel.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 8, paddingLeading: 8)
        locationSwitch.anchor(top: topAnchor, trailing: trailingAnchor, paddingTop: 8, paddingTrailing: 8)
    }
    
    @objc private func locationSwitchToggled(_ sender: UISwitch!) {
        delegate?.locationSwitchToggled(isOn: sender.isOn)
    }
}

