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
