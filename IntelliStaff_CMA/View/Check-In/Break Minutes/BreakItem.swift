//
//  BreakOutItem.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 17/08/25.
//

import SwiftUI

struct BreakItem: View {
    let id: UUID
    let name: String
    let position: String
    let schTime: Date
    var startTime: Date
    var endTime: Date
    var duration: Int
    
    var onStartTap: (UUID, Date) -> Void
    var onEndTap: (UUID, Date) -> Void
    var onSave: (UUID) -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(name)")
                    .font(.buttonFont)
                
                Text("Position: \(position)")
                    .font(.bodyFont)
                
                Text("Scheduled Time: \(Date_Time_Formatter.formatDate(schTime))")
                    .font(.bodyFont)
                
                HStack(spacing: 12) {
                    // Start Time Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Start")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Button(action: {
                            onStartTap(id, startTime)
                        }) {
                            HStack {
                                Text("\(Date_Time_Formatter.formatTime(startTime))")
                                    .foregroundColor(.theme)
                                    .font(.bodyFont)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                    
                    // End Time Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("End")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Button(action: {
                            onEndTap(id, endTime)
                        }) {
                            HStack {
                                Text("\(Date_Time_Formatter.formatTime(endTime))")
                                    .foregroundColor(.theme)
                                    .font(.bodyFont)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                    
                    // Duration Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Duration")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Button(action: {
                            print("duration pressed")
                        }) {
                            HStack {
                                Text("\(duration) min")
                                    .foregroundColor(.theme)
                                    .font(.bodyFont)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(height: 30)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                }

                
                // Save Button
                Rectangular_Rounded_Button(title: "Save") {
                    onSave(id)
                }
                .frame(height: 40)
            }
            .padding(.horizontal)
        }
    }
}


struct BreakItem_Previews: PreviewProvider {
    static var previews: some View {
        BreakItem(
            id: UUID(),
            name: "John Doe",
            position: "Developer",
            schTime: Date(),
            startTime: Date(),
            endTime: Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date(),
            duration: 30,
            onStartTap: { id, date in
                print("Start tapped for \(id), \(date)")
            },
            onEndTap: { id, date in
                print("End tapped for \(id), \(date)")
            },
            onSave: { id in
                print("Save tapped for \(id)")
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

