//
//  SwiftDataServiceTest.swift
//  MC3Tests
//
//  Created by Hansen Yudistira on 22/08/24.
//

import XCTest
@testable import MC3
import SwiftData

final class SwiftDataServiceTests: XCTestCase {

    var swiftDataService: SwiftDataService!
    
    override func setUpWithError() throws {
        swiftDataService = SwiftDataService()
        swiftDataService.container = try ModelContainer(for: Reminder.self)
        swiftDataService.context = ModelContext(swiftDataService.container!)
    }

    override func tearDownWithError() throws {
        swiftDataService = nil
    }

    func testSaveReminder() throws {
        let reminder = Reminder(title: "Test Reminder", timeSwitch: true, locationSwitch: false)
        
        swiftDataService.saveReminder(reminder: reminder)
        
        let reminders = swiftDataService.fetchReminders()
        
        XCTAssertEqual(reminders.count, 1)
        XCTAssertEqual(reminders.first?.title, "Test Reminder")
    }

    func testFetchReminders() throws {
        let reminder1 = Reminder(title: "Test Reminder 1", timeSwitch: true, locationSwitch: false)
        let reminder2 = Reminder(title: "Test Reminder 2", timeSwitch: false, locationSwitch: true)
        
        swiftDataService.saveReminder(reminder: reminder1)
        swiftDataService.saveReminder(reminder: reminder2)
        
        let reminders = swiftDataService.fetchReminders()
        
        XCTAssertEqual(reminders.count, 2)
        XCTAssertEqual(reminders[0].title, "Test Reminder 2")
        XCTAssertEqual(reminders[1].title, "Test Reminder 1")
    }

    func testUpdateReminder() throws {
        let reminder = Reminder(title: "Original Title", timeSwitch: true, locationSwitch: false)
        swiftDataService.saveReminder(reminder: reminder)
        
        swiftDataService.updateReminder(reminder: reminder, newTitle: "Updated Title")
        
        let reminders = swiftDataService.fetchReminders()
        
        XCTAssertEqual(reminders.first?.title, "Updated Title")
    }

    func testDeleteReminder() throws {
        let reminder = Reminder(title: "Test Reminder", timeSwitch: true, locationSwitch: false)
        swiftDataService.saveReminder(reminder: reminder)
        
        swiftDataService.deleteReminder(reminder: reminder)
        
        let reminders = swiftDataService.fetchReminders()
        
        XCTAssertEqual(reminders.count, 0)
    }
}

