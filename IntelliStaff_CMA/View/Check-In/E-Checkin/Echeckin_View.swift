//
//  Echeckin_View.swift
//  IntelliStaff_CMA
//
//  Created by ios on 14/08/25.
//
import SwiftUI
import SSDateTimePicker

enum ActiveAlert {
    case feedback
    case info
}

struct ECheckin_View: View {
    @Binding var path: [AppRoute]
    @State private var showTimePicker = false
    @State private var selectedDate: Date = Date()
    @State private var userRating = 2
    @State private var showFeedbackAlert = false
    @State private var feedbackText = ""
    @State private var startDate: Date? = Date()
    @State private var startTime: Time? = Time()
    @State private var isChecked: Bool = false
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var activeItemID: UUID? = nil
    @State private var activeTime: Time = Time()
    @State private var selectedTimes: [UUID: Time] = [:]
    @State private var showDeleteAlert = false
    @State private var showFeedBackAlert = false
    @State private var activeAlert: ActiveAlert?
    @State private var showLogoutAlert = false
    @State private var savedRemark: String = ""    // Persisted remark
    @State var viewModel = ECheckVM()
    var isSubmitEnabled: Bool {
        viewModel.checkinData.contains(where: { $0.isChecked })
    }
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    // Header
                    
                    // Date and Go Button
                    HStack {
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
                        
                        Button("Go") {}
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color(hex: "#111184"))
                            .cornerRadius(6)
                            .padding(.trailing)
                        
                        
                    }
                    .padding(.vertical, 8)
                    
                    

                    
                    HStack {
                        // Submit button
                        Button("Submit") {}
                            .disabled(!isSubmitEnabled)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSubmitEnabled ? Color(hex: "#111184") : Color.gray.opacity(0.2))
                            .foregroundColor(isSubmitEnabled ? .white : .gray)
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        // Info button
                        Button(action: {
                            // 👉 Your target action here (e.g. show alert)
                            withAnimation {
                                showAlert.toggle()
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .background(Color.white)
                                .foregroundColor(.gray)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                    
                   
                    

                    
                    ScrollView {
                        ForEach($viewModel.checkinData) { $record in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(record.name)
                                        .font(.headline)
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 8, height: 8)
                                    Spacer()
                                    
                                    // Checkbox
                                    Button(action: {
                                        record.isChecked.toggle()
                                    }) {
                                        Image(systemName: record.isChecked ? "checkmark.square" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                
                                }
                                
                                
                                // Rating
                                HStack(spacing: 2) {
                                    StarRatingView(rating: $userRating) { newRating in
                                        if newRating <= 2 {
                                            activeAlert = .feedback
                                            showFeedbackAlert = true
                                        }
                                    }
                                    
                                    Button {
                                        activeAlert = .info
                                        showFeedbackAlert = true
                                    } label: {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.gray)
                                            .padding(.leading, 4)
                                    }
                                    
                                    
                                }
                                .alert("Enter Remark", isPresented: $showFeedbackAlert, presenting: activeAlert) { alertType in
                                            if alertType == .feedback {
                                                TextField("Enter your remark", text: $feedbackText)
                                                Button("Submit") {
                                                    savedRemark = feedbackText   // ✅ Save the remark
                                                    print("User feedback: \(savedRemark)")
                                                    feedbackText = ""            // Clear after saving (optional)
                                                }
                                            } else if alertType == .info {
                                                Button("OK", role: .cancel) { }
                                            }
                                        } message: { alertType in
                                            if alertType == .info {
                                                Text(savedRemark.isEmpty ? "No feedback yet" : savedRemark)
                                            }
                                        }
                                    
                                

                                
                                HStack {
                                    Text("Position:")
                                        .font(.subheadline)
                                    Text(record.position)
                                        .font(.subheadline)
                                        .padding(4)
                                        .background(Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                
                                Text("Schedule Time: \(record.scheduleTime)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("Total Hours: \(record.totalHours)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("Break Minutes: \(record.breakMinutes)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Button(action: {
                                        showTimePicker = true
                                    }) {
                                        HStack {
                                            Text(startDate != nil ? Date_Time_Formatter.formatTime(startTime!) : "Enter Date")
                                                .foregroundColor(startTime == nil ? .gray : .black)
                                                .font(.buttonFont)
                                                .lineLimit(1)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Image(systemName: "clock")
                                                .foregroundColor(.theme)
                                        }
                                        .padding()
                                        .frame(height: 40)
                                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                                    }
                                    
                                    Button(action: {
                                        showTimePicker = true
                                    }) {
                                        HStack {
                                            Text(startDate != nil ? Date_Time_Formatter.formatTime(startTime!) : "Enter Date")
                                                .foregroundColor(startTime == nil ? .gray : .black)
                                                .font(.buttonFont)
                                                .lineLimit(1)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Image(systemName: "clock")
                                                .foregroundColor(.theme)
                                        }
                                        .padding()
                                        .frame(height: 40)
                                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                                    }
                                }
                                
                                HStack {
                                    let commonAction = {
                                                showDeleteAlert.toggle()
                                            }
                                            
                                            HStack {
                                                Button(action: commonAction) {
                                                    Image(systemName: "trash")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .background(.red)
                                                        .cornerRadius(8)
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: commonAction) {
                                                    Text("Save")
                                                        .foregroundColor(.white)
                                                        .frame(width: 90, height: 40)
                                                        .background(Color(hex: "#111184"))
                                                        .cornerRadius(8)
                                                }
                                                .padding(.top, 15)
                                            }
                                }
                                
                                DottedLine()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 8]))
                                    .foregroundColor(.gray)
                                    .frame(height: 1)
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 3)
                                    .padding(.top, 9)
                            }
                            .padding()
                            .background(Color(UIColor.white))
                           // .cornerRadius(12)
                           // .shadow(radius: 2)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                        }
                    }
                    
                   
                    VStack {
                           
                        }
                    .frame(maxWidth: .infinity, maxHeight: 28)
                        .padding()
                   
                }
            }
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
            
            if showDeleteAlert {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showDeleteAlert = false
                        }
                    
                    VStack {
                        AlertView(
                            image: Image(systemName: "exclamationmark.circle.fill"),
                            title: "Logout",
                            message: "Are you sure you want to logout?",
                            primaryButton: AlertButtonConfig(title: "OK", action: {
                                SessionManager.performLogout(path: $path)
                                showDeleteAlert = false   // 👈 dismiss on OK
                            }),
                            secondaryButton: AlertButtonConfig(title: "Cancel", action: {
                                showDeleteAlert = false   // 👈 dismiss on Cancel
                            }),
                            dismiss: {
                                showDeleteAlert = false   // 👈 dismiss on dismiss
                            }
                        )
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
            
            if showAlert{
                CustomAlertView(show: $showAlert)
            }
            
           
        }
        .background(Color.white)
        
        .onAppear {
            viewModel.fetchCheckinData()
        }
    }
    
    
}


struct ECheckin_View_Previews: PreviewProvider {
    @State static var mockPath: [AppRoute] = []

    static var previews: some View {
        ECheckin_View(
            path: .constant([]))
    }
}
