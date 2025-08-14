//
//  Custom_Calendar.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI
import SSDateTimePicker

struct Custom_Calander_View: View {
    @Binding var showDatePicker: Bool
    @Binding var selectedDate: Date
    
    var onDateSelection: ((Date) -> Void)? = nil
    var disabledDates: [Date] = []

    var body: some View {
        ZStack {
            SSDatePicker(showDatePicker: $showDatePicker)
                .selectedDate(selectedDate)
                .onDateSelection({ date in
                    selectedDate = date
                    onDateSelection?(date)
                })
                .popupOverlayColor(.clear)
                .disableDates(disabledDates)
        }
    }
}

#Preview {
    Custom_Calendar_Preview_Wrapper()
}

struct Custom_Calendar_Preview_Wrapper: View {
    @State private var showDatePicker = true
    @State private var selectedDate: Date = Date()

    var body: some View {
        Custom_Calander_View(
            showDatePicker: $showDatePicker,
            selectedDate: $selectedDate
        )
    }
}
