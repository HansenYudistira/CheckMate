//
//  ReminderViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 16/08/24.
//

import UIKit

class ReminderViewController: UIViewController {
    private let tableView = UITableView()
    private var reminders: [Reminder] = []
    private var filteredReminders: [Reminder] = []
    private let filterView = FilterView()
    private let titleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        fetchReminders()
        checkNotificationAuthorization()
        applyFilters()
        
        filterView.filterChanged = { [weak self] in
            self?.applyFilters()
        }
    }
    
    private func setupView() {
        let addIcon = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        var config = UIButton.Configuration.filled()
        config.image = addIcon
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold
        )
        
        let addButton = UIButton(configuration: config)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Reminders"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .left
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Check before you go!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .left
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleView.addSubview(addButton)
        
        addButton.anchor(top: titleView.topAnchor, trailing: titleView.trailingAnchor)
        titleLabel.anchor(top: titleView.topAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor)
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, leading: titleView.leadingAnchor, bottom: titleView.bottomAnchor, trailing: titleView.trailingAnchor, paddingTop: 8)
        let filterContainerView = UIView()
        filterContainerView.backgroundColor = .secondarySystemBackground
        filterContainerView.addSubview(filterView)
        filterView.anchor(
            top: filterContainerView.topAnchor,
            leading: filterContainerView.leadingAnchor,
            bottom: filterContainerView.bottomAnchor,
            trailing: filterContainerView.trailingAnchor,
            paddingTop: 8,
            paddingLeading: 16,
            paddingBottom: 8,
            paddingTrailing: 16
        )

        view.addSubview(titleView)
        view.addSubview(filterContainerView)
        view.addSubview(tableView)
        
        titleView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            paddingLeading: 16,
            paddingTrailing: 16
        )
        
        filterContainerView.anchor(
            top: titleView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            paddingTop: 16,
            height: 80
        )
        
        tableView.anchor(
            top: filterView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
        
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    private func fetchReminders() {
        reminders = SwiftDataService.shared.fetchReminders()
        NotificationCenter.default.post(name: Notification.Name("remindersUpdated"), object: nil)
        reloadData()
    }
    
    private func applyFilters() {
        filteredReminders = reminders.filter { reminder in
            var matchesLocation = true
            var matchesTime = true
            
            if filterView.locationFilterSelected {
                matchesLocation = reminder.locationSwitch
            }
            
            if filterView.timeFilterSelected {
                matchesTime = reminder.timeSwitch
            }
            
            if filterView.locationFilterSelected && filterView.timeFilterSelected {
                return matchesLocation && matchesTime
            } else if filterView.locationFilterSelected || filterView.timeFilterSelected {
                return matchesLocation && matchesTime
            } else {
                return true
            }
        }
        
        reloadData()
    }
    
    private func checkNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationAuthorization()
            case .denied:
                self.handleLocationPermissionDenied()
                print("User has denied notification permissions.")
            case .authorized, .provisional, .ephemeral:
                break
            @unknown default:
                fatalError("Unknown notification authorization status.")
            }
        }
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
                return
            }
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }
    
    private func handleLocationPermissionDenied() {
        let alert = UIAlertController(
            title: "Location Permission Denied",
            message: "Please enable location permissions in settings to use this feature.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @objc private func addButtonTapped() {
        let addReminderVC = AddReminderViewController()
        addReminderVC.modalPresentationStyle = .formSheet
        addReminderVC.delegate = self
        navigationController?.pushViewController(addReminderVC, animated: true)
    }
}

extension ReminderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as? ReminderCell else {
            return UITableViewCell()
        }
        let reminder = filteredReminders[indexPath.row]
        cell.configure(with: reminder)
        return cell
    }
}

extension ReminderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            let reminderToDelete = self.filteredReminders[indexPath.row]
            self.filteredReminders.remove(at: indexPath.row)
            
            if let originalIndex = self.reminders.firstIndex(where: { $0.id == reminderToDelete.id }) {
                self.reminders.remove(at: originalIndex)
            }
            NotificationService.shared.deleteReminder(reminderToDelete)

            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReminder = self.reminders[indexPath.row]
        print("Selected Reminder: \(selectedReminder.checklist)")
        let checklistVC = ChecklistViewController()
        checklistVC.delegate = self
        checklistVC.reminder = selectedReminder
        checklistVC.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(checklistVC, animated: true)
    }
}

extension ReminderViewController: AddReminderViewControllerDelegate {
    func didAddReminder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchReminders()
            self.applyFilters()
        }
    }
}

extension ReminderViewController: ChecklistViewControllerDelegate {
    func refreshData() {
        fetchReminders()
        applyFilters()
    }
}
