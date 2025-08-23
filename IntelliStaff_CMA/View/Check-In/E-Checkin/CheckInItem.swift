//
//  CheckInItem.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI
import SSDateTimePicker

struct CheckInItem: View {

    let item: ECheckinModal_Nw
    var selectedTime: Time
    var onTimeTap: (ECheckinModal_Nw, Time) -> Void
    var onCheckIn: (ECheckinModal_Nw, Time) -> Void
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 8) { // spacing here controls the gap
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
                
                GeometryReader { geo in
                    HStack (spacing: 8) {
                        Button(action: {
                            onTimeTap(item, selectedTime)
                        }) {
                            HStack {
                                Text(Date_Time_Formatter.formatTime(selectedTime))
                                    .foregroundColor(.theme)
                                    .font(.bodyFont)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "clock")
                                    .foregroundColor(.theme)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                        .frame(width: geo.size.width * 0.75)
                        
                        Rectangular_Rounded_Button(title: "Check In") {
                            onCheckIn(item, selectedTime)
                        }
                        .frame(width: geo.size.width * 0.25)
                    }
                    .frame(height: 40)
                }
            }
            .padding(.horizontal)
        }
    }

}

struct CheckInItem_Previews: PreviewProvider {
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
        
        return CheckInItem(
            item: mockItem,
            selectedTime: Date(),
            onTimeTap: { _, time in
                print("Time tapped: \(time)")
            },
            onCheckIn: { _, time in
                print("Checked in at \(time)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}




