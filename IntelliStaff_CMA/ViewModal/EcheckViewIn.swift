//
//  EcheckViewIn.swift
//  IntelliStaff_CMA
//
//  Created by ios on 19/08/25.
//

import SwiftUI



@MainActor
@Observable
class ECheckVM {
    
    var checkinData: [CheckInRecord] = [
        CheckInRecord(name: "Cano, Reyna", position: "Shift Supervisor- Day Shift", scheduleTime: "9:00 AM – 5:00 PM", totalHours: "8 H : 0 M", breakMinutes: "0", startTime: "9:00 AM", endTime: "5:00 PM"),
        CheckInRecord(name: "Smith, John", position: "Technician", scheduleTime: "10:00 AM – 6:00 PM", totalHours: "8 H : 0 M", breakMinutes: "30", startTime: "10:00 AM", endTime: "6:00 PM"),
        CheckInRecord(name: "Doe, Jane", position: "Operator", scheduleTime: "8:00 AM – 4:00 PM", totalHours: "8 H : 0 M", breakMinutes: "15", startTime: "8:00 AM", endTime: "4:00 PM")
    ]
    var isLoading: Bool = false
    var errorMessage: String?
    
    
    
    
    func fetchCheckinData() {
        checkinData = [
            CheckInRecord(name: "Cano, Reyna", position: "Shift Supervisor- Day Shift", scheduleTime: "9:00 AM – 5:00 PM", totalHours: "8 H : 0 M", breakMinutes: "0", startTime: "9:00 AM", endTime: "5:00 PM"),
            CheckInRecord(name: "Smith, John", position: "Technician", scheduleTime: "10:00 AM – 6:00 PM", totalHours: "8 H : 0 M", breakMinutes: "30", startTime: "10:00 AM", endTime: "6:00 PM"),
            CheckInRecord(name: "Doe, Jane", position: "Operator", scheduleTime: "8:00 AM – 4:00 PM", totalHours: "8 H : 0 M", breakMinutes: "15", startTime: "8:00 AM", endTime: "4:00 PM")
        ]
    }
}
