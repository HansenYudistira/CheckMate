//
//  SelectionButton.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class SelectionButton: UIButton {
    var selectionHandler: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        setTitle("Arriving", for: .normal)
        setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        contentHorizontalAlignment = .trailing
        semanticContentAttribute = .forceRightToLeft
        menu = createMenu()
        showsMenuAsPrimaryAction = true
        tintColor = .systemBlue
        setTitleColor(.systemBlue, for: .normal)
        print("Button title: \(title(for: .normal) ?? "No Title")")
    }

    private func createMenu() -> UIMenu {
        let arrivingAction = UIAction(title: "Arriving", image: nil) { _ in
            self.setTitle("Arriving", for: .normal)
            self.selectionHandler?("Arriving")
        }
        let leavingAction = UIAction(title: "Leaving", image: nil) { _ in
            self.setTitle("Leaving", for: .normal)
            self.selectionHandler?("Leaving")
        }

        return UIMenu(title: "", children: [arrivingAction, leavingAction])
    }
}
