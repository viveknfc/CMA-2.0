//
//  Custom_Timer.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI
import SSDateTimePicker

struct Custom_Timer: View {
    
    @Binding var showTimePicker: Bool
    @Binding var selectedTime: Time
    
    var onTimeSelection: ((Time) -> Void)? = nil
    
    var body: some View {
        ZStack {
            SSTimePicker(showTimePicker: $showTimePicker)
                .selectedTime(selectedTime)
                .onTimeSelection { time in
                    selectedTime = time
                    onTimeSelection?(time)
                }
        }
    }
}

#Preview {
    StatefulPreviewWrapper2(true, Date()) { showTimePicker, selectedTime in
        Custom_Timer(
            showTimePicker: showTimePicker,
            selectedTime: selectedTime)
    }
}

struct StatefulPreviewWrapper2<Value1, Value2, Content: View>: View {
    @State var value1: Value1
    @State var value2: Value2
    var content: (Binding<Value1>, Binding<Value2>) -> Content
    
    init(_ value1: Value1, _ value2: Value2,
         content: @escaping (Binding<Value1>, Binding<Value2>) -> Content) {
        _value1 = State(initialValue: value1)
        _value2 = State(initialValue: value2)
        self.content = content
    }
    
    var body: some View {
        content($value1, $value2)
    }
}

