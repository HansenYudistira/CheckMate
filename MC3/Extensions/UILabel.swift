//
//  UILabel.swift
//  MC3
//
//  Created by Hansen Yudistira on 14/08/24.
//

import UIKit

extension UILabel {
    convenience public init(text: String? = "",
                            font: UIFont? = UIFont.systemFont(ofSize: 12),
                            textColor: UIColor = .black,
                            textAlignment: NSTextAlignment = .left,
                            numberOfLines: Int = 1) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
