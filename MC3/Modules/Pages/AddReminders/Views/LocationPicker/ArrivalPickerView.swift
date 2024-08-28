//
//  ArrivalPickerView.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class ArrivalPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let options = ["Arriving", "Leaving"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected: \(options[row])")
    }
}
