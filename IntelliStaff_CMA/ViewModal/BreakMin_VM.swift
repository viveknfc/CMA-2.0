//
//  BreakMin_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//

import SwiftUI

@MainActor
@Observable
class Break_VM {
    
    var breakData: [Break_Min_Modal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // MARK: - Fetch Dummy Data
    func fetchBreakData() {
        breakData = [
            Break_Min_Modal(
                name: "Vivek",
                position: "iOS",
                scheduledTime: Date(),
                startTime: Date(),
                endTime: Date().addingTimeInterval(900) // 15 min
            ),
            Break_Min_Modal(
                name: "John",
                position: "Android",
                scheduledTime: Date(),
                startTime: Date().addingTimeInterval(3600),
                endTime: Date().addingTimeInterval(4500) // +15 min
            ),
            Break_Min_Modal(
                name: "Sarah",
                position: "Backend",
                scheduledTime: Date(),
                startTime: Date().addingTimeInterval(7200),
                endTime: Date().addingTimeInterval(7500) // +5 min
            )
        ]
    }
    
    // MARK: - Update Start Time
    func updateStartTime(for id: UUID, newStart: Date) {
        if let index = breakData.firstIndex(where: { $0.id == id }) {
            breakData[index].startTime = newStart
        }
    }
    
    // MARK: - Update End Time
    func updateEndTime(for id: UUID, newEnd: Date) {
        if let index = breakData.firstIndex(where: { $0.id == id }) {
            breakData[index].endTime = newEnd
        }
    }
    
    // MARK: - Save / Submit Action
    func saveBreak(for id: UUID) {
        if let item = breakData.first(where: { $0.id == id }) {
            print("Saved break for \(item.name): \(item.duration) minutes")
        }
    }
}
