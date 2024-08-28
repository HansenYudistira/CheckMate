//
//  SearchButton.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class SearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = .secondarySystemBackground
        
        layer.cornerRadius = 10
        
        setTitle("Search", for: .normal)
        setTitleColor(.gray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        let searchIcon = UIImage(systemName: "magnifyingglass")
        setImage(searchIcon, for: .normal)
        tintColor = .gray
        
        semanticContentAttribute = .forceLeftToRight
        contentHorizontalAlignment = .leading
    }
}

