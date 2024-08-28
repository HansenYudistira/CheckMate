//
//  ReminderManager.swift
//  MC3
//
//  Created by Hansen Yudistira on 15/08/24.
//

import Foundation

//class ReminderManager {
//    static let shared = ReminderManager()
//    
//    private var reminders: [Reminder] = []
//    
//    func addReminder(_ reminder: Reminder) {
//        reminders.append(reminder)
//        NotificationService.shared.scheduleNotification(for: reminder)
//        if reminder.location != nil {
//            LocationService.shared.startMonitoring(reminder: reminder)
//        }
//    }
//    
//    func removeReminder(_ reminder: Reminder) {
//        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
//            reminders.remove(at: index)
////            NotificationService.shared.removeNotification(for: reminder)
//            if reminder.location != nil {
//                LocationService.shared.stopMonitoring(reminder: reminder)
//            }
//        }
//    }
//    
//    
//}
