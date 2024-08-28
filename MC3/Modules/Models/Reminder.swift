//
//  Reminder.swift
//  MC3
//
//  Created by Hansen Yudistira on 15/08/24.
//

import SwiftData
import Foundation

@Model
class Reminder: ObservableObject {
    @Attribute(.unique) var id: UUID
    @Attribute var title: String
    @Attribute var timeSwitch: Bool
    @Attribute var time: Date?
    @Attribute var days: [Int]?
    @Attribute var notificationType: String?
    @Attribute var locationLatitude: Double?
    @Attribute var locationLongitude: Double?
    @Attribute var placeMark: String?
    @Attribute var radius: Double?
    @Attribute var locationSwitch: Bool
    @Attribute var checklist: [String]
    @Attribute var colorTag: String
    @Attribute var symbolTag: String
    @Attribute var createdAt: Date
    
    init(id: UUID = UUID(), title: String, timeSwitch: Bool, time: Date? = nil, days: [Int]? = [], notificationType: String? = nil, locationLatitude: Double? = nil, locationLongitude: Double? = nil, placeMark: String? = nil, radius: Double? = nil, locationSwitch: Bool, checklist: [String] = [], colorTag: String, symbolTag: String, createdAt: Date = Date.now
    ) {
        self.id = id
        self.title = title
        self.timeSwitch = timeSwitch
        self.time = time
        self.days = days
        self.notificationType = notificationType
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.placeMark = placeMark
        self.radius = radius
        self.locationSwitch = locationSwitch
        self.checklist = checklist
        self.colorTag = colorTag
        self.symbolTag = symbolTag
        self.createdAt = createdAt
    }
}
