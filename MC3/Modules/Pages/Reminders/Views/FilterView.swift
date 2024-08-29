//
//  FilterView.swift
//  MC3
//
//  Created by Hansen Yudistira on 22/08/24.
//

import UIKit

class FilterView: UIStackView {
    var locationFilterSelected: Bool = false
    var timeFilterSelected: Bool = false
    var filterChanged: (() -> Void)?
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter by:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: "Black")
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
        button.addTarget(FilterView.self, action: #selector(locationButtonTapped), for: .touchUpInside)
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
        button.addTarget(FilterView.self, action: #selector(timeButtonTapped), for: .touchUpInside)
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
    }
    
    @objc private func locationButtonTapped() {
        locationFilterSelected.toggle()
        updateButtonAppearance(button: locationButton, isSelected: locationFilterSelected)
        filterChanged?()
    }
    
    @objc private func timeButtonTapped() {
        timeFilterSelected.toggle()
        updateButtonAppearance(button: timeButton, isSelected: timeFilterSelected)
        filterChanged?()
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

