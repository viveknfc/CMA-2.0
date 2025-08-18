//
//  Date_Time_Formatter.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//

import Foundation

struct Date_Time_Formatter {
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static func formatTime(_ time: Date) -> String {
        return timeFormatter.string(from: time)
    }
    
    static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func formattedDate(_ date: Date) -> String {
        return mediumDateFormatter.string(from: date)
    }
}
