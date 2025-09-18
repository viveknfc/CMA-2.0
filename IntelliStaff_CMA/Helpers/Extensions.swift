//
//  Extensions.swift
//  IntelliStaff_EMA
//
//  Created by Vivek Lakshmanan on 15/07/25.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

extension Color {
    init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r, g, b: Double
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255

            self = Color(red: r, green: g, blue: b)
            return
        }

        return nil
    }
}

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}







extension String {
    func toDateTimeString() -> String? {
        // Possible time formats ("8.00 am" or "8:00 AM")
        let possibleFormats = ["h.mm a", "h:mm a"]

        var parsedDate: Date? = nil

        for format in possibleFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            inputFormatter.amSymbol = "AM"
            inputFormatter.pmSymbol = "PM"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")

            if let date = inputFormatter.date(from: self) {
                parsedDate = date
                break
            }
        }

        guard let date = parsedDate else {
            return nil
        }

        // Output: "1900-01-01T08:00:00"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "'1900-01-01'T'HH:mm:ss"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        return outputFormatter.string(from: date)
    }
}
