//
//  NotificationService.swift
//  MC3
//
//  Created by Hansen Yudistira on 15/08/24.
//

import UserNotifications
import CoreLocation

class NotificationService {
    static let shared = NotificationService()
    
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        
        if let firstChecklistItem = reminder.checklist.first {
            content.body = firstChecklistItem
        } else {
            content.body = ""
        }

        content.sound = .default
        
        if reminder.timeSwitch {
            if let days = reminder.days {
                if let time = reminder.time {
                    for day in days {
                        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                        dateComponents.weekday = day
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        let request = UNNotificationRequest(identifier: "\(reminder.id.uuidString)-\(day)", content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                            if let error = error {
                                print("Failed to schedule notification: \(error.localizedDescription)")
                            }
                        })
                    }
                }
            }
        }
        
        if reminder.locationSwitch, 
            let latitude = reminder.locationLatitude,
            let longitude = reminder.locationLongitude,
            let radius = reminder.radius {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = CLCircularRegion(center: location, radius: radius, identifier: reminder.id.uuidString)
            if reminder.notificationType == "Arriving" {
                region.notifyOnEntry = true
            }
            
            if reminder.notificationType == "Leaving" {
                region.notifyOnExit = true
            }
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if let error = error {
                    print("Failed to schedule location-based notification: \(error.localizedDescription)")
                }
            })
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        let notificationCenter = UNUserNotificationCenter.current()
        var identifiers: [String] = []
        for i in 1...8 {
            identifiers.append("\(reminder.id.uuidString)-\(i)")
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
        
        SwiftDataService.shared.deleteReminder(reminder: reminder)
    }
}
