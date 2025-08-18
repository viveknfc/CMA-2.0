//
//  Break_Min.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//

import SwiftUI

enum TimeType {
    case start
    case end
}

struct Break_Min: View {
    
    @State private var showDatePicker = false
    @State private var selectedDate: Date = Date()
    @State private var startDate: Date? = Date()
    
    @State private var showTimePicker = false
    @State private var activeItemID: UUID? = nil
    @State private var activeTime: Date = Date()
    @State private var activeTimeType: TimeType? = nil   // Start or End
    
    @State private var selectedTimes: [UUID: (start: Date, end: Date)] = [:]
    
    @State var viewModel = Break_VM()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 20) {
                dateSelectionField
                
                breakList
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .padding()
            
            if showDatePicker {
                datePickerOverlay
            }
            
            if showTimePicker {
                timePickerOverlay
            }
        }
        .onAppear {
            viewModel.fetchBreakData()
        }
    }
}

// MARK: - Subviews
extension Break_Min {
    
    private var dateSelectionField: some View {
        HStack(spacing: 16) {
            Button(action: { showDatePicker = true }) {
                HStack {
                    Text(startDate != nil ? Date_Time_Formatter.formattedDate(startDate!) : "Enter Date")
                        .foregroundColor(startDate == nil ? .gray : .black)
                        .font(.buttonFont)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "calendar")
                        .foregroundColor(.theme)
                }
                .padding()
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
        }
    }
    
    private var breakList: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.breakData) { item in
                    BreakItem(
                        id: item.id,
                        name: item.name,
                        position: item.position,
                        schTime: item.scheduledTime,
                        startTime: selectedTimes[item.id]?.start ?? item.startTime,
                        endTime: selectedTimes[item.id]?.end ?? item.endTime,
                        duration: {
                            if let times = selectedTimes[item.id] {
                                return max(Int(times.end.timeIntervalSince(times.start) / 60), 0)
                            } else {
                                return item.duration
                            }
                        }(),
                        onStartTap: { id, time in
                            activeItemID = id
                            activeTime = time
                            activeTimeType = .start
                            showTimePicker = true
                        },
                        onEndTap: { id, time in
                            activeItemID = id
                            activeTime = time
                            activeTimeType = .end
                            showTimePicker = true
                        },
                        onSave: { id in
                            viewModel.saveBreak(for: id)
                        }
                    )
                    
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
                        .foregroundColor(.gray)
                        .frame(height: 1)
                        .padding(.horizontal, 15)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var datePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showDatePicker = false }
            
            Custom_Calander_View(
                showDatePicker: $showDatePicker,
                selectedDate: $selectedDate,
                onDateSelection: { date in
                    selectedDate = date
                    startDate = date
                    print("Start Date Selected: \(Date_Time_Formatter.formattedDate(date))")
                    showDatePicker = false
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
        .zIndex(10)
    }
    
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showTimePicker = false }
            
            Custom_Timer(showTimePicker: $showTimePicker, selectedTime: $activeTime) { pickedTime in
                if let id = activeItemID, let type = activeTimeType {
                    // Get the model for this break
                    guard let model = viewModel.breakData.first(where: { $0.id == id }) else { return }
                    
                    var times = selectedTimes[id] ?? (start: model.startTime, end: model.endTime)
                    
                    switch type {
                    case .start:
                        times.start = combine(date: model.scheduledTime, with: pickedTime)
                    case .end:
                        times.end = combine(date: model.scheduledTime, with: pickedTime)
                    }
                    
                    selectedTimes[id] = times   // update dictionary
                    print("Selected \(type) time for \(id): \(pickedTime)")
                    
                    // 👉 Optionally update duration immediately
                    let duration = max(Int(times.end.timeIntervalSince(times.start) / 60), 0)
                    print("Duration for \(id): \(duration) mins")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(10)
    }
    
    func combine(date: Date, with time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        
        return calendar.date(from: merged) ?? date
    }

}


#Preview {
    Break_Min()
}
