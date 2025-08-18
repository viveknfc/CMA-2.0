//
//  Check-In.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 13/08/25.
//

import SwiftUI
import SSDateTimePicker

struct Check_In: View {
    
    @State private var showDatePicker = false
    @State private var selectedDate: Date = Date()
    @State private var startDate: Date? = Date()
    
    @State private var showTimePicker = false
    @State private var activeItemID: UUID? = nil
    @State private var activeTime: Time = Time()
    @State private var selectedTimes: [UUID: Time] = [:]

    
    @State var viewModel = ECheckin_VM()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        // Start Date Field
                        Button(action: {
                            showDatePicker = true
                        }) {
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
                    
                    ScrollView {
                        VStack (spacing: 30){
                            ForEach(viewModel.checkinData) { item in
                                CheckInItem(
                                    id: item.id,
                                    firstName: item.name,
                                    position: item.position,
                                    schTime: item.scheduledTime,
                                    selectedTime: selectedTimes[item.id] ?? item.selectedTime,
                                    onTimeTap: { id, time in
                                            activeItemID = id
                                            activeTime = time
                                            showTimePicker = true
                                        },
                                    onCheckIn: { id, time in
                                        print("Checked in for \(id) at \(Date_Time_Formatter.formatTime(time))")
                                    }
                                    )
                                
                                DottedLine()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
                                    .foregroundColor(.gray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 4)
                                    .padding(.top, 20)
                            }
                            
                            
                        }
                        .padding(.bottom, 100)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 20)
                .padding()
                
                // Date Picker Overlay
                if showDatePicker {
                    
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showDatePicker = false
                            }
                        
                        VStack {
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
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Add this
                            .clipped()

                        }
                    }
                    .zIndex(10)
                }
                
                if showTimePicker {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showTimePicker = false
                            }

                        Custom_Timer(showTimePicker: $showTimePicker, selectedTime: $activeTime) { time in
                            if let id = activeItemID {
                                selectedTimes[id] = time
                                print("the seelcted time from check in is \(time)")
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .zIndex(10)
                }

            }
        }
        .onAppear {
            viewModel.fetchCheckinData()
        }
    }
    
}

#Preview {
    Check_In()
}
