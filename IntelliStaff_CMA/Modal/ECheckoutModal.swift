//
//  ECheckoutModal.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//
import Foundation

struct ECheckoutModal: Codable, Identifiable {
    var id = UUID()
    var name: String
    var position: String
    var scheduledTime: Date
    var selectedTime: Date
}
