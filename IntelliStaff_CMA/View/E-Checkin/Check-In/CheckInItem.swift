//
//  CheckInItem.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI
import SSDateTimePicker

struct CheckInItem: View {

    let id: UUID
    let firstName: String
    let position: String
    let schTime: Date
    
    var selectedTime: Time
    
    var onTimeTap: (UUID, Time) -> Void
    var onCheckIn: (UUID, Time) -> Void
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 8) { // spacing here controls the gap
                Text("Name: \(firstName)")
                    .font(.buttonFont)
                
                Text("Position: \(position)")
                    .font(.bodyFont)
                
                Text("Scheduled Time: \(formatDate(schTime))")
                    .font(.bodyFont)
                
                GeometryReader { geo in
                    HStack (spacing: 8) {
                        Button(action: {
                            onTimeTap(id, selectedTime)
                        }) {
                            HStack {
                                Text(formatTime(selectedTime))
                                    .foregroundColor(.theme)
                                    .font(.buttonFont)
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
                            onCheckIn(id, selectedTime)
                        }
                        .frame(width: geo.size.width * 0.25)
                    }
                    .frame(height: 40)
                }
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            print("Tap reached CheckInItem")
        }
    }
    
    private func formatTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: time)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }

}

struct CheckInItem_Previews: PreviewProvider {
    static var previews: some View {
        CheckInItem(
            id: UUID(),
            firstName: "John Doe",
            position: "Manager",
            schTime: Date(),
            selectedTime: Date(),
            onTimeTap: { id, time in
                print("Time tapped: \(time)")
            },
            onCheckIn: { id, time in
                print("Checked in at \(time)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}



