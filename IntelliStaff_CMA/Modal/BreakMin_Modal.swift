//
//  BreakMin_Modal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//
import Foundation

struct Break_Min_Modal: Codable, Identifiable {
    var id = UUID()
    var name: String
    var position: String
    var scheduledTime: Date
    var startTime: Date
    var endTime: Date
    
    var duration: Int {
        let interval = endTime.timeIntervalSince(startTime)
        return max(Int(interval / 60), 0) // avoid negative values
    }
}
