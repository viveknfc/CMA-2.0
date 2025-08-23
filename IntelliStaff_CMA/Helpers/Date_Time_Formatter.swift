//
//  Date_Time_Formatter.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//

import Foundation
import SSDateTimePicker

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
    
    private static let APIdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    // 🔹 New API DateTime formatter
    private static let apiDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current //TimeZone(secondsFromGMT: 0) // or .current if API needs local
        return formatter
    }()
    
    /// Server (UTC) formatter
    static let serverFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC") // server = UTC
        return formatter
    }()
    
    /// Convert current local date → UTC string for server
    static func nowForServer() -> String {
        let now = Date()
        let minusFiveHours = now.addingTimeInterval(-5 * 60 * 60) // -5 hours
        return serverFormatter.string(from: minusFiveHours)
    }
    
    static func formatTime(_ time: Date) -> String {
        return timeFormatter.string(from: time)
    }
    
    static func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func APIformatDate(_ date: Date) -> String {
        return APIdateFormatter.string(from: date)
    }
    
    static func formattedDate(_ date: Date) -> String {
        return mediumDateFormatter.string(from: date)
    }
    
    static func APIformatDateTime(_ date: Date) -> String {
        return apiDateTimeFormatter.string(from: date)
    }
    
    /// Converts API datetime string ("yyyy-MM-dd'T'HH:mm:ss") to Date
    static func apiTimeToDate(from string: String) -> Date? {
        return serverFormatter.date(from: string) // serverFormatter = UTC
    }
    
    /// Converts Date → API datetime string ("yyyy-MM-dd'T'HH:mm:ss")
    static func dateToApiString(_ date: Date) -> String {
        return serverFormatter.string(from: date)
    }
    
    static func disabledDatesExceptTodayAndYesterday() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        // Generate a wide range of dates (e.g., ±1 year) and disable everything except today & yesterday
        let start = calendar.date(byAdding: .year, value: -1, to: today)!
        let end = calendar.date(byAdding: .year, value: 1, to: today)!
        
        var disabled: [Date] = []
        var current = start
        while current <= end {
            if current != today && current != yesterday {
                disabled.append(current)
            }
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return disabled
    }
    
    static func extractTimeIn12HourFormat(from dateTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // matches API format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // adjust if needed
        
        if let date = dateFormatter.date(from: dateTime) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h:mm a"   // 12-hour format
            return outputFormatter.string(from: date)
        }
        return nil
    }

}
