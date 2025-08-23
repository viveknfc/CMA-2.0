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
    
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    
    @State var viewModel = ECheckin_VM()
  
    let clientID: Int?
    let contactID: Int?
    
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
                        
                        if viewModel.eCheckinData.isEmpty {
                            VStack {
                                Text(viewModel.noDataMessage ?? "No check-in data available")
                                    .foregroundColor(.gray)
                                    .font(.buttonFont)
                                    .padding(.top, 150)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        else {
                            VStack (spacing: 30){
                                ForEach(viewModel.eCheckinData) { item in
                                    CheckInItem(
                                        item: item,
                                        selectedTime: activeTime,
                                        onTimeTap: { item, time in
                                            activeTime = time
                                            showTimePicker = false
                                        },
                                        onCheckIn: { selectedItem, time in       print("check in pressed")
                                            if let clientID = clientID,
                                               let contactID = contactID {
                                                viewModel.checkInSubmit(
                                                    item: selectedItem,
                                                    clientId: clientID,
                                                    contactId: contactID, type: "IN",
                                                    errorHandler: errorHandler
                                                )
                                            }
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

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 20)
                .padding()
                
                // 🔔 Show custom alert if triggered
                if viewModel.showAlert, let message = viewModel.alertMessage {
                    if viewModel.alertType == .success {
                        // ✅ Only one OK button
                        AlertView(
                            title: "Check-In",
                            message: message,
                            primaryButton: AlertButtonConfig(title: "OK") {
                                viewModel.showAlert = false
                            },
                            dismiss: {
                                viewModel.showAlert = false
                            },
                            alertType: .success
                        )
                    } else {
                        // ❌ Error case → Retry + Cancel
                        AlertView(
                            title: "Check-In",
                            message: message,
                            primaryButton: AlertButtonConfig(title: "Retry") {
                                if let firstItem = viewModel.eCheckinData.first,
                                   let clientID = clientID,
                                   let contactID = contactID {
                                    viewModel.checkInSubmit(
                                        item: firstItem,
                                        clientId: clientID,
                                        contactId: contactID,
                                        type: "IN",
                                        errorHandler: errorHandler,
                                        isRetry: true
                                    )
                                }
                                viewModel.showAlert = false
                            },
                            secondaryButton: AlertButtonConfig(title: "Cancel") {
                                viewModel.showAlert = false
                            },
                            dismiss: {
                                viewModel.showAlert = false
                            },
                            alertType: .error
                        )
                    }
                }
                
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
                                    
                                    viewModel.fetchCheckinData(
                                        clientId: "\(clientID ?? 0)",
                                        contactId: "\(contactID ?? 0)",
                                        weekEnd: Date_Time_Formatter.APIformatDate(date),
                                        errorHandler: errorHandler
                                    )
                                    
                                    showDatePicker = false
                                }, disabledDates: Date_Time_Formatter.disabledDatesExceptTodayAndYesterday()
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
            if let clientID = clientID,
               let contactID = contactID {
                
                viewModel.fetchCheckinData(
                    clientId: "\(clientID)",
                    contactId: "\(contactID)",
                    weekEnd: Date_Time_Formatter.APIformatDate(Date()),
                    errorHandler: errorHandler
                )
            } else {
                print("❌ Missing clientID or contactID")
                errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            }
        }
        
        if viewModel.isLoading {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            TriangleLoader()
        }
    }
    
}

#Preview {
    Check_In(clientID: 1, contactID: 1)
        .environmentObject(GlobalErrorHandler())
}
