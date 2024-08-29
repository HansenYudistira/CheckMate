//
//  FilterView.swift
//  MC3
//
//  Created by Hansen Yudistira on 22/08/24.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterChanged(locationFilter: Bool, timeFilter: Bool)
}

class FilterView: UIStackView {
    var locationFilterSelected: Bool = false
    var timeFilterSelected: Bool = false
    var filterChanged: (() -> Void)?
    
    weak var delegate: FilterViewDelegate?
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "BlackColor")
        return label
    }()
    
    private let locationButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Location"
        config.baseForegroundColor = .systemGray
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30)
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    private let timeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Time"
        config.baseForegroundColor = .systemGray
        config.baseBackgroundColor = .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30)
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        axis = .vertical
        alignment = .leading
        spacing = 4
        let buttonStack = UIStackView(arrangedSubviews: [locationButton, timeButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.alignment = .fill
        
        addArrangedSubview(filterLabel)
        addArrangedSubview(buttonStack)
        
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func locationButtonTapped() {
        locationFilterSelected.toggle()
        updateButtonAppearance(button: locationButton, isSelected: locationFilterSelected)
        delegate?.filterChanged(locationFilter: locationFilterSelected, timeFilter: timeFilterSelected)
    }
    
    @objc private func timeButtonTapped() {
        timeFilterSelected.toggle()
        updateButtonAppearance(button: timeButton, isSelected: timeFilterSelected)
        delegate?.filterChanged(locationFilter: locationFilterSelected, timeFilter: timeFilterSelected)
    }
    
    private func updateButtonAppearance(button: UIButton, isSelected: Bool) {
        if isSelected {
            button.configuration?.baseForegroundColor = .white
            button.configuration?.baseBackgroundColor = .systemBlue
        } else {
            button.configuration?.baseForegroundColor = .systemGray
            button.configuration?.baseBackgroundColor = .systemBackground
        }
    }
}

