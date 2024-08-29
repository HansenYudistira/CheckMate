//
//  ChecklistViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit
import CoreLocation

protocol ChecklistViewControllerDelegate: AnyObject {
    func refreshData()
}

class ChecklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    weak var delegate: ChecklistViewControllerDelegate?
    var tableView = UITableView()
    var reminder: Reminder?
    let symbolButton = UIButton(type: .system)
    var colorButton = UIButton(type: .system)
    var buttonStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .secondarySystemBackground
        
        symbolButton.setImage(UIImage(systemName: reminder?.symbolTag ?? "sparkles"), for: .normal)
        symbolButton.tintColor = .white
        setupSymbolMenu()
        
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .systemGray
        config.baseBackgroundColor = .systemGray6
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        colorButton = UIButton(configuration: config)
        colorButton.setTitle("Change Color", for: .normal)
        colorButton.layer.cornerRadius = 8
        setupColorMenu()
        
        buttonStack = UIStackView(arrangedSubviews: [symbolButton, colorButton])
        buttonStack.axis = .horizontal
        buttonStack.backgroundColor = color(from: reminder?.colorTag ?? "systemOrange")
        buttonStack.distribution = .equalCentering
        
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4

        let titleLabel = UILabel()
        titleLabel.text = reminder?.title ?? "Untitled"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(named: "Black")

        let locationLabel = UILabel()
        locationLabel.text = reminder?.placeMark ?? "-"
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = .systemGray

        let timeLabel = UILabel()
        if let reminderTime = reminder?.time {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeLabel.text = dateFormatter.string(from: reminderTime)
        } else {
            timeLabel.text = "No time"
        }
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .systemGray
        
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(systemName: "location.fill")
        locationIcon.tintColor = .systemGray
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let timeIcon = UIImageView()
        timeIcon.image = UIImage(systemName: "clock.fill")
        timeIcon.tintColor = .systemGray
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let locationStack = UIStackView()
        locationStack.axis = .horizontal
        locationStack.spacing = 8
        locationStack.addArrangedSubview(locationIcon)
        locationStack.addArrangedSubview(locationLabel)
        
        let timeStack = UIStackView()
        timeStack.axis = .horizontal
        timeStack.spacing = 8
        timeStack.addArrangedSubview(timeIcon)
        timeStack.addArrangedSubview(timeLabel)

        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.addTarget(self, action: #selector(editReminder), for: .touchUpInside)

        let locationTimeStackView = UIStackView(arrangedSubviews: [locationLabel, timeLabel])
        locationTimeStackView.axis = .vertical
        locationTimeStackView.spacing = 8
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let mainStackView = UIStackView(arrangedSubviews: [locationTimeStackView, spacerView, editButton])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .leading

        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, mainStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8

        cardView.addSubview(verticalStackView)
        
        view.addSubview(buttonStack)
        
        symbolButton.anchor(leading: buttonStack.leadingAnchor, paddingLeading: 8, width: 50)
        colorButton.anchor(top: buttonStack.topAnchor, bottom: buttonStack.bottomAnchor, trailing: buttonStack.trailingAnchor, paddingTop: 16, paddingBottom: 32, paddingTrailing: 16)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 80)
        ])

        editButton.anchor(trailing: mainStackView.trailingAnchor)
        
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            verticalStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])

        self.view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChecklistViewCell.self, forCellReuseIdentifier: "TodoCell")
        view.addSubview(tableView)
        
        let addNewButton = UIButton(type: .system)
        addNewButton.setTitle("+ Add New", for: .normal)
        addNewButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        addNewButton.tintColor = .systemGray
        addNewButton.contentHorizontalAlignment = .leading
        addNewButton.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        footerView.addSubview(addNewButton)
        addNewButton.translatesAutoresizingMaskIntoConstraints = false
        addNewButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        addNewButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = footerView
        
        tableView.anchor(top: cardView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 8, paddingLeading: 16, paddingBottom: 16, paddingTrailing: 16)
    }
    
    private func setupNavBar() {
        navigationItem.title = "To Check List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func showSymbolPicker() {
        let symbolPicker = UIAlertController(title: "Select Symbol", message: nil, preferredStyle: .actionSheet)
        
        let symbols = ["party.popper.fill", "videoprojector.fill", "balloon.fill", "frying.pan.fill", "bed.double.fill", "popcorn.fill", "sink.fill", "shower.fill", "fan.ceiling.fill", "chandelier.fill"]
        symbols.forEach { symbol in
            let action = UIAlertAction(title: symbol, style: .default) { [weak self] _ in
                self?.updateSymbol(symbol)
            }
            action.setValue(UIImage(systemName: symbol), forKey: "image")
            symbolPicker.addAction(action)
        }
        
        symbolPicker.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(symbolPicker, animated: true)
    }
    
    private func setupSymbolMenu() {
        let symbolPickerMenu = UIMenu(options: .displayAsPalette, children: [
            UIAction(image: UIImage(systemName: "party.popper.fill"), handler: { _ in self.updateSymbol("party.popper.fill") }),
            UIAction(image: UIImage(systemName: "videoprojector.fill"), handler: { _ in self.updateSymbol("videoprojector.fill") }),
            UIAction(image: UIImage(systemName: "balloon.fill"), handler: { _ in self.updateSymbol("balloon.fill") }),
            UIAction(image: UIImage(systemName: "frying.pan.fill"), handler: { _ in self.updateSymbol("frying.pan.fill") }),
            UIAction(image: UIImage(systemName: "bed.double.fill"), handler: { _ in self.updateSymbol("bed.double.fill") }),
            UIAction(image: UIImage(systemName: "popcorn.fill"), handler: { _ in self.updateSymbol("popcorn.fill") }),
            UIAction(image: UIImage(systemName: "sink.fill"), handler: { _ in self.updateSymbol("sink.fill") }),
            UIAction(image: UIImage(systemName: "shower.fill"), handler: { _ in self.updateSymbol("shower.fill") }),
            UIAction(image: UIImage(systemName: "fan.ceiling.fill"), handler: { _ in self.updateSymbol("fan.ceiling.fill") }),
            UIAction(image: UIImage(systemName: "chandelier.fill"), handler: { _ in self.updateSymbol("chandelier.fill") })
        ])

        symbolButton.menu = symbolPickerMenu
        symbolButton.showsMenuAsPrimaryAction = true
    }
    
    private func updateSymbol(_ symbolName: String) {
        symbolButton.setImage(UIImage(systemName: symbolName), for: .normal)
        reminder?.symbolTag = symbolName
    }
    
    private func setupColorMenu() {
        let colorPickerMenu = UIMenu(options: .displayAsPalette, preferredElementSize: .large, children: [
            UIAction(image: createColorImage(.systemCyan), handler: { _ in self.updateColor(.systemCyan) }),
            UIAction(image: createColorImage(.systemOrange), handler: { _ in self.updateColor(.systemOrange) }),
            UIAction(image: createColorImage(.systemBrown), handler: { _ in self.updateColor(.systemBrown) }),
            UIAction(image: createColorImage(.systemBlue), handler: { _ in self.updateColor(.systemBlue) })
        ])
        
        colorButton.menu = colorPickerMenu
        colorButton.showsMenuAsPrimaryAction = true
    }
    
    private func createColorImage(_ color: UIColor) -> UIImage? {
        let size = CGSize(width: 400, height: 400)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func updateColor(_ color: UIColor) {
        buttonStack.backgroundColor = color
        reminder?.colorTag = colorName(from: color)
    }
    
    private func color(from colorName: String) -> UIColor {
        switch colorName {
        case "systemCyan":
            return .systemCyan
        case "systemOrange":
            return .systemOrange
        case "systemBrown":
            return .systemBrown
        case "systemBlue":
            return .systemBlue
        default:
            return .systemGray
        }
    }
    
    @objc private func editReminder() {
        let editReminderVC = AddReminderViewController()
        editReminderVC.delegate = self
        editReminderVC.reminder = reminder
        editReminderVC.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(editReminderVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        if let reminder = reminder {
            NotificationService.shared.deleteReminder(reminder)
            
            SwiftDataService.shared.saveReminder(reminder: reminder)
            NotificationService.shared.scheduleNotification(for: reminder)
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = self.view.center
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                self.delegate?.refreshData()
                
                self.popOrDismiss()
            }
        }
    }
    
    func getPlacemarkName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? "Unnamed place"
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
    
    private func popOrDismiss() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func colorName(from color: UIColor) -> String {
        switch color {
        case UIColor.systemCyan:
            return "systemCyan"
        case UIColor.systemOrange:
            return "systemOrange"
        case UIColor.systemBrown:
            return "systemBrown"
        case UIColor.systemBlue:
            return "systemBlue"
        default:
            return "Unknown Color"
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminder?.checklist.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! ChecklistViewCell
        cell.textField.text = reminder?.checklist[indexPath.row]
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        cell.textField.placeholder = "Enter todo"
        return cell
    }

    @objc func addNewTodo() {
        if let checklist = reminder?.checklist, !checklist.isEmpty {
            let lastItem = checklist.last
            if lastItem?.isEmpty == true {
                return
            }
        }
        
        reminder?.checklist.append("")
        let newIndexPath = IndexPath(row: (reminder?.checklist.count ?? 1) - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: newIndexPath) as? ChecklistViewCell {
                cell.textField.becomeFirstResponder()
            }
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            reminder?.checklist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ChecklistViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        reminder?.checklist[textField.tag] = updatedText
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let row = textField.tag
        reminder?.checklist[row] = textField.text ?? ""

        if let text = textField.text, !text.isEmpty {
            addNewTodo()
        }

        textField.resignFirstResponder()
        
        return true
    }
}

extension ChecklistViewController: AddReminderViewControllerDelegate {
    func didAddReminder() {
        delegate?.refreshData()
    }
}
