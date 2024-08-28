//
//  LocationSegmentedControl.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class LocationSegmentedControl: UISegmentedControl {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        insertSegment(withTitle: "Small", at: 0, animated: false)
        insertSegment(withTitle: "Medium", at: 1, animated: false)
        insertSegment(withTitle: "Wide", at: 2, animated: false)
        selectedSegmentIndex = 0
    }
}


