//
//  SwiftDataService.swift
//  MC3
//
//  Created by Hansen Yudistira on 15/08/24.
//

import SwiftData

class SwiftDataService {
    static var shared = SwiftDataService()
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            container = try ModelContainer(for: Reminder.self)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print("Error initializing database container:", error)
        }
    }

    func saveReminder(reminder: Reminder?) {
        guard let reminder = reminder else { return }
        
        if let context = context {
            
            context.insert(reminder)
            print("saved Succesfully!")
        }
    }
    
    func fetchReminders() -> [Reminder] {
        let descriptor = FetchDescriptor<Reminder>(sortBy: [
            .init(\.createdAt, order: .reverse)
        ])

        if let context = context {
            do {
                let data = try context.fetch(descriptor)
                return data
            } catch {
                print("Error when fetching Data")
            }
        }
        
        return []
    }
    
    func updateReminder(reminder: Reminder, newTitle: String) {
        let reminderToBeUpdated = reminder
        reminderToBeUpdated.title = newTitle
    }
    
    func deleteReminder(reminder: Reminder){
        guard let context = context else {
            print("Error: Context is nil")
            return
        }
        
        context.delete(reminder)
    }
}
