//
//  CheckoutItem.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 16/08/25.
//

import SwiftUI
import SSDateTimePicker

struct CheckoutItem: View {
    let id: UUID
    let firstName: String
    let position: String
    let schTime: Date
    
    var selectedTime: Time
    
    var onTimeTap: (UUID, Time) -> Void
    var onCheckOut: (UUID, Time) -> Void
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 8) { // spacing here controls the gap
                Text("Name: \(firstName)")
                    .font(.buttonFont)
                
                Text("Position: \(position)")
                    .font(.bodyFont)
                
                Text("Scheduled Time: \(Date_Time_Formatter.formatDate(schTime))")
                    .font(.bodyFont)
                
                GeometryReader { geo in
                    HStack (spacing: 8) {
                        Button(action: {
                            onTimeTap(id, selectedTime)
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
                        
                        Rectangular_Rounded_Button(title: "Check Out") {
                            onCheckOut(id, selectedTime)
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

struct CheckOutItem_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutItem(
            id: UUID(),
            firstName: "John Doe",
            position: "Manager",
            schTime: Date(),
            selectedTime: Date(),
            onTimeTap: { id, time in
                print("Time tapped: \(time)")
            },
            onCheckOut: { id, time in
                print("Checked in at \(time)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
