//
//  BreakOutItem.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//

import SwiftUI
import SSDateTimePicker

struct BreakItem: View {
    
    let item: ECheckinModal_Nw
    var startTime: Time
    var endTime: Time
    
    private var computedDuration: Int {
        max(Int(endTime.timeIntervalSince(startTime) / 60), 0)
    }
    
    var onStartTap: (ECheckinModal_Nw, Time) -> Void
    var onEndTap: (ECheckinModal_Nw, Time) -> Void
    var onSave: (ECheckinModal_Nw, Int) -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(item.candidateName)")
                    .font(.buttonFont)
                
                (Text("Position: ")
                    .font(.bodyFont)
                    .foregroundColor(.primary))
                +
                (Text(item.position)
                    .font(.bodyFont)
                    .foregroundColor(Color(hex: item.positionLabelColor)))
                
                Text("Scheduled Time: \(item.scheduleTime)")
                    .font(.bodyFont)
                
                HStack(spacing: 12) {
                    BreakTime(title: "Start",
                              value: Date_Time_Formatter.formatTime(startTime)) {
                        onStartTap(item, startTime)
                    }
                    
                    BreakTime(title: "End",
                              value: Date_Time_Formatter.formatTime(endTime)) {
                        onEndTap(item, endTime)
                    }
                    
                    BreakTime(title: "Duration",
                              value: "\(computedDuration) min") {
                        print("duration pressed")
                    }
                }

                
                // Save Button
                Rectangular_Rounded_Button(title: "Save") {
                    onSave(item, computedDuration)
                }
                .frame(height: 40)
            }
            .padding(.horizontal)
        }
    }
}


struct BreakItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockItem = ECheckinModal_Nw(
            orderId: 123,
            checkIn: "0001-01-01T00:00:00",
            positionLabelColor: "#ff6600",
            position: "Manager",
            weekEnd: "2025-08-24T00:00:00",
            endTime: "1900-01-01T18:00:00",
            candId: 456,
            startTime: "1900-01-01T17:00:00",
            isAdminUser: 0,
            reportTo: "CEO",
            payForBreak: true,
            recCode: "REC001",
            candidateName: "John Doe",
            checkOut: "0001-01-01T00:00:00",
            billDate: "2025-08-18T00:00:00",
            breakMinutes: 0,
            timeIn: "",
            timeOut: ""
        )
        
       return  BreakItem(
            item: mockItem,
            startTime: Date(),
            endTime: Date(),
            onStartTap: { id, date in
                print("Start tapped for \(id), \(date)")
            },
            onEndTap: { id, date in
                print("End tapped for \(id), \(date)")
            },
            onSave: { id, duration in
                print("Save tapped for \(id)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

