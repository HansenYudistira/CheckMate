//
//  TitleView.swift
//  MC3
//
//  Created by Hansen Yudistira on 19/08/24.
//

import UIKit

protocol TitleViewDelegate: AnyObject {
    func titleViewDidChange(_ titleView: TitleView, text: String)
}

class TitleView: UIStackView {
    weak var delegate: TitleViewDelegate?
    
    let titleLabel = UILabel()
    let titleTextView = UITextView()
    
    var title: String? {
        didSet {
            titleTextView.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextView.backgroundColor = .systemBackground
        titleTextView.font = UIFont.systemFont(ofSize: 18)
        titleTextView.layer.cornerRadius = 12
        titleTextView.delegate = self
        
        axis = .vertical
        spacing = 8
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(titleTextView)
        titleTextView.anchor(height: 100)
    }
}

extension TitleView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.titleViewDidChange(self, text: textView.text)
    }
}
