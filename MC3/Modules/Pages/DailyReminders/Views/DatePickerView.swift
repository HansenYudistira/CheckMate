//
//  DatePickerView.swift
//  MC3
//
//  Created by Hansen Yudistira on 22/08/24.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func datePickerView(_ datePickerView: DatePickerView, didSelectDate date: Date)
}

class DatePickerView: UIView {
    weak var delegate: DatePickerViewDelegate?
    private let collectionView: UICollectionView
    private var selectedIndex: IndexPath?
    var dates: [DateModel] = []
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        setupCollectionView()
        generateDates()
        scrollToToday()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor,trailing: trailingAnchor, paddingTop: 32)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(DatePickerCell.self, forCellWithReuseIdentifier: DatePickerCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func generateDates() {
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<8 {
            if let futureDate = calendar.date(byAdding: .day, value: i, to: today) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                let dayName = dateFormatter.string(from: futureDate)
                
                dateFormatter.dateFormat = "dd"
                let date = dateFormatter.string(from: futureDate)
                
                let dateModel = DateModel(dayName: dayName, date: date)
                dates.append(dateModel)
            }
        }
        collectionView.reloadData()
    }
    
    private func scrollToToday() {
        let todayIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: todayIndexPath, at: .centeredHorizontally, animated: true)
        selectedIndex = todayIndexPath
    }
    
    func getSelectedDate() -> Date? {
        guard let selectedIndex = selectedIndex else { return nil }
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: .day, value: selectedIndex.item, to: today)
    }
    
    
}

extension DatePickerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DatePickerCell.identifier, for: indexPath) as? DatePickerCell else {
            return UICollectionViewCell()
        }
        let dateModel = dates[indexPath.row]
        let isSelected = indexPath == selectedIndex
        cell.configure(with: dateModel, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        collectionView.reloadData()
        
        if let selectedDate = getSelectedDate() {
            delegate?.datePickerView(self, didSelectDate: selectedDate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: collectionView.bounds.height)
    }
}

