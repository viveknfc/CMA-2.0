//
//  E-Checkin_VM.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import Foundation

@MainActor
@Observable
class ECheckin_VM {
    
    var checkinData: [ECheckinModal] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    func fetchCheckinData() {
        checkinData = [
            ECheckinModal(
                name: "Vivek",
                position: "iOS",
                scheduledTime: Date(),
                selectedTime: Date()
            ),
            ECheckinModal(
                name: "John",
                position: "Android",
                scheduledTime: Date().addingTimeInterval(3600),
                selectedTime: Date()
            ),
            ECheckinModal(
                name: "Sarah",
                position: "Backend",
                scheduledTime: Date().addingTimeInterval(7200),
                selectedTime: Date()
            )
        ]
    }
}
