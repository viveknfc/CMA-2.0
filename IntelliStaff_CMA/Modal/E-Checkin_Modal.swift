//
//  E-Checkin_Modal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import Foundation

struct ECheckinModal: Codable, Identifiable {
    var id = UUID()
    var name: String
    var position: String
    var scheduledTime: Date
    var selectedTime: Date
}


struct CheckInRecord: Identifiable {
    let id = UUID()
    let name: String
    let position: String
    let scheduleTime: String
    let totalHours: String
    let breakMinutes: String
    let startTime: String
    let endTime: String
    var isChecked: Bool = false  // <-- Add this
}



