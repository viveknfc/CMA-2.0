//
//  ECheckIn_Modal.swift
//  IntelliStaff_CMA
//
//  Created by ios on 18/08/25.
//

import SwiftUI

struct Employee: Identifiable {
    let id = UUID()  // <-- Required for Identifiable

    var isSelected: Bool = false
    var name: String
    var position: String
    var schedule: String
    var checkIn: String
    var checkOut: String
    var totalHours: String
    var breakMinutes: String
    var rating: Int  // If used with StarRatingView, consider changing to Int
}
