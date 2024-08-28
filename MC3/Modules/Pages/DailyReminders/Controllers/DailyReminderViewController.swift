//
//  DailyReminderViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class DailyReminderViewController: UIViewController {
    private let datePickerView = DatePickerView()
    private let tableView = UITableView()
    private let titleView = UIView()
    private var reminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.delegate = self
        view.backgroundColor = .systemBackground
        setupView()
        fetchRemindersbyDate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRemindersUpdated), name: Notification.Name("remindersUpdated"), object: nil)
    }
    
    private func setupView() {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Daily"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .left
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Check before you go!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .left
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        view.addSubview(titleView)
        view.addSubview(datePickerView)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        titleLabel.anchor(top: titleView.topAnchor, leading: titleView.leadingAnchor, trailing: titleView.trailingAnchor)
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, leading: titleView.leadingAnchor, bottom: titleView.bottomAnchor, trailing: titleView.trailingAnchor, paddingTop: 8)
        titleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingLeading: 24)
        datePickerView.anchor(top: titleView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 100)
        tableView.anchor(top: datePickerView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    @objc private func handleRemindersUpdated() {
        fetchRemindersbyDate()
    }
    
    private func fetchRemindersbyDate() {
        reminders = SwiftDataService.shared.fetchReminders()
        guard let selectedDate = datePickerView.getSelectedDate() else { return }
        let calendar = Calendar.current
        let selectedWeekday = calendar.component(.weekday, from: selectedDate)
        let filteredReminders = reminders.filter { reminder in
            if let days = reminder.days {
                return days.contains(selectedWeekday)
            } else {
                return false
            }
        }
        
        self.reminders = filteredReminders
        reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    
}

extension DailyReminderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as? ReminderCell else {
            return UITableViewCell()
        }
        let reminder = reminders[indexPath.row]
        cell.configure(with: reminder)
        return cell
    }
}
extension DailyReminderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReminder = self.reminders[indexPath.row]
        let checklistVC = ChecklistViewController()
        checklistVC.delegate = self
        checklistVC.reminder = selectedReminder
        checklistVC.modalPresentationStyle = .formSheet
        navigationController?.pushViewController(checklistVC, animated: true)
    }
}

extension DailyReminderViewController: DatePickerViewDelegate {
    func datePickerView(_ datePickerView: DatePickerView, didSelectDate date: Date) {
        fetchRemindersbyDate()
    }
}

extension DailyReminderViewController: ChecklistViewControllerDelegate {
    func refreshData() {
        fetchRemindersbyDate()
    }
}

extension DailyReminderViewController: AddReminderViewControllerDelegate {
    func didAddReminder() {
        self.fetchRemindersbyDate()
    }
}
