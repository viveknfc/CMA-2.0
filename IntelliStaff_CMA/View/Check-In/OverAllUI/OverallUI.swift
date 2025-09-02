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

enum ReasonType: String, CaseIterable {
    case leftEarly = "Left Early"
    case arriveLate = "Arrive Late"
    case replacement = "Replacement"
    case askToWorkAdditional = "Ask to work additional time"
    case sentHome = "Sent Home"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct OverAllUI: View {
    @State private var showTimePicker = false
    @State private var selectedDate: Date = Date()
    @State private var userRating = 0
    @State private var showFeedbackAlert = false
    @State private var feedbackText = ""
    @State private var startDate: Date? = Date()
    @State private var tappedDate: Date? = Date()
    @State private var startTime: Time? = Time()
    @State private var isChecked: Bool = false
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var activeItemID: UUID? = nil
    @State private var activeTime: Time = Time()
    @State private var selectedTimes: [UUID: Time] = [:]
    @State private var activeTimeType: TimeType = .start
    @State private var activeRecordKey: String = ""
    @State private var showDeleteAlert = false
    @State private var showSaveAlert = false
    @State private var showFeedBackAlert = false
    @State private var activeAlert: ActiveAlert?
    @State private var showLogoutAlert = false
    @State private var savedRemark: String = ""
    @State private var selectedStartTimes: [String: Time] = [:]
    @State private var selectedEndTimes: [String: Time] = [:]
    var totalSelected: [ECheckInAllResponse] = []
    var notValidArrayList: [[String:Any]] = []
    @State private var activeRecordForDeletion: ECheckInAllResponse? = nil
    @State private var deleteCandidateName: String = ""
    // New dropdown states
    @State private var showReasonDropdown: [Int: Bool] = [:]
    @State private var selectedReasons: [Int: ReasonType] = [:]
    @State private var reasonComments: [Int: String] = [:]
    @State private var showReasonAlert = false
    @State private var activeReasonRecordID = 0
    @State private var tempReasonComment = ""
    @State private var alertTitle = ""
   @State private var alertTitleColor: Color = .black
   @State private var alertTitleBg: Color = .white
   @State private var buttonBg: Color = .blue
   @State private var buttonTitleColor: Color = .white
    // MARK: - Add state variable for delete confirmation
    @State private var activeRecordForSave: ECheckInAllResponse? = nil
    let clientID: Int?
    let contactID: Int?
    @State private var startSelectedTime:String? = ""
    @State private var endSelectedTime:String? = ""
    @StateObject private var checkboxManager = CheckboxManager()
    @State var viewModel = ECheckVM()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    @State private var items: [AllItem] = []
    
    var isSubmitEnabled: Bool {
        checkboxManager.submissionArray.count > 1
    }
    
    var canSave: Bool {
        guard let res = viewModel.echeckallData.first else { return false }
        return res.isSubmitted == 0   // enabled only if not submitted
    }

    var canDelete: Bool {
        guard let res = viewModel.echeckallData.first else { return false }
        return res.isSubmitted == 0   // enabled only if not submitted
    }



    
    var isreasonSubmitEnabled:Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            mainContentView
            overlayViews
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 100) // extra safe space for last element
        .onAppear {
            handleViewAppear()
        }
        
        if viewModel.isLoading {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            TriangleLoader()
        }
        
        // Alert handling
        if viewModel.showAlert, let message = viewModel.alertMessage {
            if viewModel.alertType == .success {
                AlertView(
                    title: "EMA 2.0",
                    message: message,
                    primaryButton: AlertButtonConfig(title: "OK") {
                        viewModel.showAlert = false
                    },
                    dismiss: {
                        viewModel.showAlert = false
                    },
                    alertType: .success
                )
            }else {
                AlertView(
                    title: "EMA 2.0",
                    message: message,
                    primaryButton: AlertButtonConfig(title: "Retry") {
                        if let firstItem = viewModel.echeckallData.first,
                           let clientID = clientID,
                           let contactID = contactID {
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
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        VStack(spacing: 0) {
            headerSection
            recordsScrollView
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 6) { // reduced spacing
            dateAndGoSection
            submitAndInfoSection
        }
        .padding(.horizontal, 12) // tighter padding
        .padding(.vertical, 4)    // reduced height
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Date and Go Section
    private var dateAndGoSection: some View {
        HStack(spacing: 6) { // tighter spacing
            datePickerButton
            goButton
        }
    }

    private var datePickerButton: some View {
        Button(action: {
            showDatePicker = true
        }) {
            HStack(spacing: 6) {
                Text(datePickerText)
                    .foregroundColor(startDate == nil ? Color(.systemGray) : Color(.label))
                    .font(.system(size: 16, weight: .medium)) // smaller font
                    .frame(maxWidth: .infinity, alignment: .center)

                Image(systemName: "calendar")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 16)) // medium icon
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8) // reduced height
            .background(Color.init(hex: "#778da9"))
            .cornerRadius(8) // slightly smaller radius
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }

    private var goButton: some View {
        Button("Go") {
            guard let clientID = clientID,
                  let contactID = contactID else {
                print("❌ Missing clientID or contactID")
                errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
                return
            }
            if let startDate = tappedDate {
                viewModel.fetchOverallDetails(
                    contactId: "\(contactID)",
                    clientId: "\(clientID)",
                    weekEnd: Date_Time_Formatter.APIformatDate(startDate),
                    errorHandler: errorHandler
                )
            }
        }
        .font(.system(size: 16, weight: .semibold)) // medium font
        .foregroundColor(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 8) // reduced height
        .background(Color(hex: "#111184"))
        .cornerRadius(8)
    }

    // MARK: - Submit and Info Section
    private var submitAndInfoSection: some View {
        HStack {
            Spacer()
            submitButton
            Spacer()
            infoButton
        }
    }

    private var submitButton: some View {
        Button("Submit") {
            print("Got the Submission Array ------- \(checkboxManager.submissionArray)")
            viewModel.overallSubmit(params: checkboxManager.submissionArray, errorHandler: errorHandler)
        }
        .disabled(checkboxManager.submissionArray.isEmpty)
        .font(.system(size: 13, weight: .semibold)) // medium font
        .foregroundColor(!checkboxManager.submissionArray.isEmpty ? .white : Color(.systemGray2))
        .padding(.horizontal, 20)
        .padding(.vertical, 8) // reduced height
        .background(!checkboxManager.submissionArray.isEmpty ? Color(hex: "#111184") : Color(.systemGray5))
        .cornerRadius(8)
    }

    
    
    private var datePickerText: String {
        if let startDate = startDate {
            return Date_Time_Formatter.formattedDate(startDate)
        } else {
            return "Enter Date"
        }
    }

    private var infoButton: some View {
        Button(action: {
            withAnimation {
                showAlert.toggle()
            }
        }) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray3))
        }
    }
    
    // MARK: - Records ScrollView
    private var recordsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.echeckallData.indices, id: \.self) { index in
                    recordCardView(
                        record: viewModel.echeckallData[index],
                        index: index
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Record Card View
    
    // MARK: - Record Header with Checkbox
    private func recordHeaderView(record: ECheckInAllResponse) -> some View {
        HStack {
            Text(record.candidateName ?? "Unknown")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Circle()
                .fill(record.isSubmitted == 1 ? Color.green : Color.orange)
                .frame(width: 8, height: 8)
            
            Spacer()
            
            // Checkbox Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    // Wrap async call in Task
                    checkboxManager.clientid = clientID ?? 0
                    checkboxManager.contactid = contactID ?? 0
                    checkboxManager.startSelectedTime = startSelectedTime ?? ""
                    checkboxManager.endSelectedTime = endSelectedTime ?? ""
                    checkboxManager.toggleRecord(record)
                    
                }
            }) {
                Image(systemName: checkboxManager.isSelected(record.id) ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(checkboxManager.isSelected(record.id) ? .blue : Color(.systemGray3))
            }
        }
    }

    // MARK: - Record Card View
    private func recordCardView(record: ECheckInAllResponse, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            recordHeaderView(record: record)
            recordDetailsView(record: record)
            timePickersView(for: record)
            reasonDropdownView(for: record, reason: .arriveLate,comment: "")
            recordActionsView(for: record)
           // recordActionsView
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
        .alert("Enter Remark", isPresented: $showFeedbackAlert, presenting: activeAlert) { alertType in
            if alertType == .feedback {
                TextField("Enter your remark", text: $feedbackText)
                Button("Submit") {
                    savedRemark = feedbackText
                    print("User feedback: \(savedRemark)")
                    viewModel.fetchFeedbackDeatils(
                        clientId: "\(clientID ?? 0)",
                        weekEnd: viewModel.echeckallData[index].weekEnd,
                        rating: String(userRating),
                        source: String(userRating),
                        CandId: "\(viewModel.echeckallData[index].candID)",
                        OrderId: "\(viewModel.echeckallData[index].orderID)",
                        comments: feedbackText,
                        ClientContacts: String(contactID ?? 0),
                        errorHandler: errorHandler
                    )
                    feedbackText = ""
                }
                Button("Cancel", role: .cancel) { }
            } else if alertType == .info {
                Button("OK", role: .cancel) { }
            }
        } message: { alertType in
            if alertType == .info {
                Text(savedRemark.isEmpty ? "No feedback yet" : savedRemark)
            }
        }
        .alert("Add Comment", isPresented: $showReasonAlert) {
            TextField("Enter comment for irregular hours", text: $tempReasonComment)
            Button("Save Reason") {
                reasonComments[activeReasonRecordID] = tempReasonComment
                
                if let record = viewModel.echeckallData.first(where: { $0.id == activeReasonRecordID }),
                   let selectedReason = selectedReasons[activeReasonRecordID] {
                    viewModel.selectReasonDetails(
                        responseData: record,
                        reasonID: record.id,
                        reasonType: selectedReason.rawValue,
                        reasonComment: tempReasonComment,
                        ClientId: clientID ?? 0,
                        ContactId: contactID ?? 0,
                        errorHandler: errorHandler
                    )
                }
                
                tempReasonComment = ""
                print("Reason saved with comment: \(reasonComments[activeReasonRecordID] ?? "")")
            }
            Button("Cancel", role: .cancel) {
                tempReasonComment = ""
            }
        } message: {
            Text("Please provide additional details for the selected reason.")
        }
        
    }
    
    // MARK: - New Reason Dropdown View
    private func reasonDropdownView(for record: ECheckInAllResponse, reason: ReasonType, comment: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                // Dropdown Button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        let recordID = record.id
                        showReasonDropdown[recordID] = !(showReasonDropdown[recordID] ?? false)
                    }
                }) {
                    HStack(spacing: 8) {
                        Text(selectedReasons[record.id]?.displayName ?? "Reason For Irregular Hours")
                            .foregroundColor(selectedReasons[record.id] != nil ? Color(.label) : Color(.systemGray))
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Image(systemName: showReasonDropdown[record.id] == true ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color(.systemGray2))
                            .font(.system(size: 12, weight: .medium))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
                .disabled(record.isSubmitted == 1) // 🔒 Disable dropdown when submitted
                .opacity(record.isSubmitted == 1 ? 0.5 : 1) // Greyed out
                
                
                // Save Reason Button
                Button(action: {
                    if record.isSubmitted == 0 {
                        viewModel.selectReasonDetails(
                            responseData: record,
                            reasonID: record.id,
                            reasonType: reason.rawValue,
                            reasonComment: comment,
                            ClientId: clientID ?? 0,
                            ContactId: contactID ?? 0,
                            errorHandler: errorHandler
                        )
                    }
                }) {
                    Image(systemName: record.isSubmitted == 1 ? "lock.fill" : "square.and.arrow.down")
                        .foregroundColor(record.isSubmitted == 1 ? .gray : .green)
                        .font(.system(size: 16))
                        .frame(width: 32, height: 32)
                        .background(
                            (record.isSubmitted == 1 ? Color.gray.opacity(0.2) : Color.green.opacity(0.1))
                        )
                        .cornerRadius(6)
                }
                .disabled(record.isSubmitted == 1) // 🔒 Disable save button
            }
            
            // Dropdown Menu
            if showReasonDropdown[record.id] == true && record.isSubmitted == 0 {
                VStack(spacing: 0) {
                    ForEach(ReasonType.allCases, id: \.self) { reason in
                        Button(action: {
                            selectedReasons[record.id] = reason
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showReasonDropdown[record.id] = false
                            }
                            
                            if reason == .other {
                                activeReasonRecordID = record.id
                                showReasonAlert = true
                            }
                        }) {
                            HStack {
                                Text(reason.displayName)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.label))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                if selectedReasons[record.id] == reason {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 12, weight: .medium))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                        }
                        .background(Color.white)
                        
                        if reason != ReasonType.allCases.last {
                            Divider()
                                .padding(.leading, 12)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color(.systemGray4).opacity(0.3), radius: 3, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
    }

    
    // MARK: - Star Rating Section
    private var starRatingSection: some View {
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
           .padding(.vertical, 8)
       }
    
    // MARK: - Time Picker Button
    private func timePickerButton(for record: ECheckInAllResponse, timeType: TimeType, placeholder: String) -> some View {
        Button(action: {
            switch timeType {
            case .start:
                activeRecordKey = record.checkIn
            case .end:
                activeRecordKey = record.checkOut
            }
            activeTimeType = timeType
            showTimePicker = true
        }) {
            HStack(spacing: 8) {
                Text(timePickerText(for: record, timeType: timeType, placeholder: placeholder))
                    .foregroundColor(getSelectedTime(for: record, timeType: timeType) == nil ? Color(.black) : Color(.label))
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "clock.fill")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.init(hex: "#778da9"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemBlue), lineWidth: 1)
            )
        }
    }
    
    private func timePickerText(for record: ECheckInAllResponse, timeType: TimeType, placeholder: String) -> String {
        if let selectedTime = getSelectedTime(for: record, timeType: timeType) {
            return Date_Time_Formatter.formatTime(selectedTime)
        } else {
            return placeholder
        }
    }
    
    private func getSelectedTime(for record: ECheckInAllResponse, timeType: TimeType) -> Time? {
        switch timeType {
        case .start:
            return selectedStartTimes[record.checkIn]
        case .end:
            return selectedEndTimes[record.checkOut]
        }
    }
    
    // MARK: - Record Header
    private mutating func recordHeaderView(record: ECheckInAllResponse, index: Int) -> some View {
        HStack {
            Text(record.candidateName ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.label))
            
            Circle()
                .fill(Color.yellow)
                .frame(width: 8, height: 8)
            
            Spacer()
           // checkboxButton(record: record, index: index)
        }
    }
    
    // MARK: - Submit Section
    private var submitSection: some View {
        VStack(spacing: 12) {
            if checkboxManager.hasSelectedRecords {
                HStack {
                    Text("Ready to submit \(checkboxManager.selectedCount) record(s)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button("View JSON") {
                        if let jsonData = checkboxManager.getSubmissionData(),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("JSON Data:\n\(jsonString)")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
            }
            
            HStack(spacing: 16) {
                Button("Submit Selected") {
                    submitSelectedRecords()
                }
                .disabled(!checkboxManager.hasSelectedRecords)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(checkboxManager.hasSelectedRecords ? Color.blue : Color(.systemGray4))
                .cornerRadius(10)
                
                Button("Debug") {
                    debugSubmissionArray()
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 80)
                .padding(.vertical, 14)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Helper Methods
//    private func handleViewAppear() {
//        // Load initial data
//        print("View appeared - loading initial data")
//        
//    }
    
    private func submitSelectedRecords() {
        guard checkboxManager.hasSelectedRecords else { return }
        
        if let jsonData = checkboxManager.getSubmissionData() {
            print("Submitting \(checkboxManager.selectedCount) records")
            
            // Your API submission logic here
            // Example: viewModel.submitRecords(jsonData: jsonData)
            
            // Clear selections after successful submission
            checkboxManager.clearAll()
        }
    }
    
    private func debugSubmissionArray() {
        print("\n=== DEBUG SUBMISSION ARRAY ===")
        print("Selected IDs: \(checkboxManager.selectedRecords)")
        print("Array count: \(checkboxManager.submissionArray.count)")
        
        for (index, dict) in checkboxManager.submissionArray.enumerated() {
            print("\nRecord \(index + 1):")
            print("  ID: \(dict["Id"] ?? "N/A")")
            print("  Name: \(dict["CandidateName"] ?? "N/A")")
            print("  Total Hours: \(dict["TotalHours"] ?? "N/A")")
        }
        
        if let jsonData = checkboxManager.getSubmissionData(),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nJSON Output:\n\(jsonString)")
        }
        print("=== END DEBUG ===\n")
    }
    

    
    // MARK: - Record Details
    private func recordDetailsView(record: ECheckInAllResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            starRatingSection
            positionView(record: record)
            scheduleTimeView(record: record)
            totalHoursView(record: record)
            breakMinutesView(record: record)
        }
    }
    
    // MARK: - Record Actions
    private func recordActionsView(for record: ECheckInAllResponse) -> some View {
        HStack {
            deleteButton(for: record)
            Spacer()
            saveButton(for: record)
        }
        .padding(.top, 8)
    }

    private func deleteButton(for record: ECheckInAllResponse) -> some View {
        Button(action: {
            // Set the active record for deletion confirmation
            activeRecordForDeletion = record
            deleteCandidateName = record.candidateName ?? "this candidate"
            showDeleteAlert = true
        }) {
            Image(systemName: "trash.fill")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 32, height: 32)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
        }
       // .disabled(record.isSubmitted == 1) // Disable if already submitted
        .disabled(record.isSubmitted == 1) // Disable if already submitted
        .opacity(record.isSubmitted == 1 ? 0.5 : 1.0)
        .alert("Delete Record",
               isPresented: $showDeleteAlert,
               presenting: activeRecordForDeletion) { record in
            Button("Delete", role: .destructive) {
               // deleteIndividualRecord(record, clientID: clientID ?? 0, contactID: contactID ?? 0)
                viewModel.deleteRecords(responseData: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), errorHandler: errorHandler)
                activeRecordForDeletion = nil
            }
            Button("Cancel", role: .cancel) {
                activeRecordForDeletion = nil
            }
        } message: { record in
            Text("Are you sure you want to delete this record for \(record.candidateName ?? "this candidate")?")
        }
    }

    private func saveButton(for record: ECheckInAllResponse) -> some View {
        Button(action: {
            viewModel.saveRecordDetails(response: record, contactId: String(contactID ?? 0) , clientId: String(clientID ?? 0), checkin: startSelectedTime ?? record.checkIn, checkout: endSelectedTime ?? record.checkOut, note: "", errorHandler: errorHandler)
           // saveIndividualRecord(record)
        }) {
            Text("Save")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(record.isSubmitted == 1 ? Color(.systemGray4) : Color(hex: "#111184"))
                .cornerRadius(8)
        }
        .disabled(record.isSubmitted == 1) // Disable if already submitted
        .opacity(record.isSubmitted == 1 ? 0.5 : 1.0)
        .alert("Save Record",
               isPresented: $showSaveAlert,
               presenting: activeRecordForSave) { record in
            Button("Save", role: .destructive) {
               // deleteIndividualRecord(record, clientID: clientID ?? 0, contactID: contactID ?? 0)
                //viewModel.deleteRecords(responseData: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), errorHandler: errorHandler)
                //viewModel.saveRecordDetails(response: record, contactId: String(contactID ?? 0) , clientId: String(clientID ?? 0), errorHandler: errorHandler)
                activeRecordForSave = nil
            }
            Button("Cancel", role: .cancel) {
                activeRecordForSave = nil
            }
        } message: { record in
            Text("Are you sure you want to delete this record for \(record.candidateName ?? "this candidate")?")
        }
    }

    
    private func positionView(record: ECheckInAllResponse) -> some View {
        HStack(spacing: 8) {
            Text("Position:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text(record.position)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: record.positionLabelColor))
                .cornerRadius(4)
            
            Spacer()
        }
    }
    
    private func scheduleTimeView(record: ECheckInAllResponse) -> some View {
        HStack {
            Text("Schedule Time:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.startTime.toTimeAMPM() ?? "") - \(record.endTime.toTimeAMPM() ?? "")")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
    
    private func totalHoursView(record: ECheckInAllResponse) -> some View {
        HStack {
            Text("Total Hours:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.totalHours)")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
    
    private func breakMinutesView(record: ECheckInAllResponse) -> some View {
        HStack {
            Text("Break Minutes:")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
            
            Text("\(record.breakMinutes)")
                .font(.system(size: 14))
                .foregroundColor(Color(.label))
            
            Spacer()
        }
    }
    
    private func delete(record: ECheckInAllResponse) {
        viewModel.deleteRecords(responseData: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), errorHandler: errorHandler)
    }
    
    
    // MARK: - Time Pickers
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showTimePicker = false
                }
            
            Custom_Timer(
                showTimePicker: $showTimePicker,
                selectedTime: $activeTime
            ) { time in
                switch activeTimeType {
                case .start:
                    selectedStartTimes[activeRecordKey] = time
                    startSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                    print("Start time selected for record \(activeRecordKey): \(time)")
                case .end:
                    selectedEndTimes[activeRecordKey] = time
                    endSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                    print("End time selected for record \(activeRecordKey): \(time)")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(10)
    }
    
    // MARK: - Record Actions
    private var recordActionsView: some View {
        HStack {
            trashButton
            Spacer()
            saveButton
        }
        .padding(.top, 8)
    }
    
    private var trashButton: some View {
        Button(action: {
            showDeleteAlert.toggle()
        }) {
            Image(systemName: "trash.fill")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 32, height: 32)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            showSaveAlert.toggle()
            // Add save action here with reason data
        }) {
            Text("Save")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color(.theme))
                .cornerRadius(8)
                
            
        }
    }
    
    // MARK: - Overlay Views
    private var overlayViews: some View {
        ZStack {
            if showDatePicker {
                datePickerOverlay
            }
            
            if showDeleteAlert {
                deleteAlertOverlay
            }
            
            if showSaveAlert{
                saveAlertOverlay
            }
            
            if showTimePicker {
                timePickerOverlay
            }
            
            if showAlert {
                CustomAlertView(show: $showAlert)
            }
        }
    }
    
    // MARK: - Date Picker Overlay
    private var datePickerOverlay: some View {
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
                        tappedDate = date
                        print("Start Date Selected: \(Date_Time_Formatter.formattedDate(date))")
                        showDatePicker = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
        }
        .zIndex(10)
    }
    
    // Updated alert overlay:
    private var deleteAlertOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showDeleteAlert = false
                }
            
            VStack {
//                AlertView(
//                    image: Image(systemName: "exclamationmark.circle.fill"),
//                    title: "Delete Record",
//                    message: "Are you sure you want to delete this record for \(deleteCandidateName)?",
//                    primaryButton: AlertButtonConfig(title: "Delete", action: {
//                        if let recordToDelete = activeRecordForDeletion {
//                            deleteIndividualRecord(recordToDelete)
//                        }
//                        showDeleteAlert = false
//                        activeRecordForDeletion = nil
//                        deleteCandidateName = ""
//                    }),
//                    secondaryButton: AlertButtonConfig(title: "Cancel", action: {
//                        showDeleteAlert = false
//                        activeRecordForDeletion = nil
//                        deleteCandidateName = ""
//                    }),
//                    dismiss: {
//                        showDeleteAlert = false
//                        activeRecordForDeletion = nil
//                        deleteCandidateName = ""
//                    }
//                )
            }
        }
        .zIndex(10)
    }
    
    // MARK: - Time Picker Overlay
    private func timePickersView(for record: ECheckInAllResponse) -> some View {
        HStack(spacing: 12) {
            timePickerButton(
                for: record,
                timeType: .start,
                placeholder: record.checkIn.toTimeAMPM() ?? "1:22 AM"
            )
            
            timePickerButton(
                for: record,
                timeType: .end,
                placeholder: record.checkOut.toTimeAMPM() ?? "1:27 AM"
            )
        }
    }
    
    // MARK: - Helper Methods
    private func handleViewAppear() {
        guard let clientID = clientID,
              let contactID = contactID else {
            print("❌ Missing clientID or contactID")
            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            return
        }
        
        viewModel.fetchOverallDetails(
            contactId: "\(contactID)",
            clientId: "\(clientID)",
            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
            errorHandler: errorHandler
        )
    }
    
    private func saveReasonForRecord(_ record: ECheckInAllResponse) {
        guard let selectedReason = selectedReasons[record.id] else {
            errorHandler.showError(message: "Please select a reason first", mode: .toast)
            return
        }
        
        if selectedReason == .other {
            activeReasonRecordID = record.id
            showReasonAlert = true
        } else {
            saveReasonToAPI(for: record, reason: selectedReason, comment: "")
        }
    }
    
    private func saveReasonToAPI(for record: ECheckInAllResponse, reason: ReasonType, comment: String) {
        let params: [String: Any] = [
            "CandId": record.candID,
            "OrderId": record.orderID,
            "WeekEnd": record.weekEnd,
            "BillDate": record.billDate,
            "Id": record.id,
            "ReasonType": reason.rawValue,
            "ReasonComment": comment,
            "ClientId": clientID ?? 0,
            "ContactId": contactID ?? 0
        ]
        
        print("Saving reason for record \(record.id): \(reason.rawValue)")
        print("API Params:", params)
        
        viewModel.selectReasonDetails(
            responseData: record,
            reasonID: record.id,
            reasonType: reason.rawValue,
            reasonComment: comment,
            ClientId: clientID ?? 0,
            ContactId: contactID ?? 0,
            errorHandler: errorHandler
        )
    }
    
    private func deleteItem(_ items: [ECheckInAllResponse]) {
        for item in items {
            print("Delete button pressed for item \(item.id)")
            
            let params: [String: Any] = [
                "CandId": item.candID,
                "OrderId": item.orderID,
                "WeekEnd": item.weekEnd,
                "BillDate": item.billDate,
                "StartTime": item.startTime,
                "EndTime": item.endTime,
                "CheckIn": item.checkIn,
                "CheckOut": item.checkOut,
                "Id": item.id,
                "breakMinutes": item.breakMinutes,
                "totlaHours": item.totalHours,
                "IPAddress": getIPv4Address() ?? "Not Found",
                "ReasonType": selectedReasons[item.id]?.rawValue ?? "",
                "ReasonComment": reasonComments[item.id] ?? ""
            ]
            
            print("Params for API call:", params)
            
           // viewModel.deleteRecords(params: params, errorHandler: errorHandler)
        }
    }
    

    private func showAlert(title: String, message: String) {
        // Implementation for showing alerts
    }
    
    private func saveIndividualRecord(_ record: ECheckInAllResponse) {
        guard record.isSubmitted == 0 else {
            errorHandler.showError(message: "Record is already submitted", mode: .toast)
            return
        }
        
        guard let clientID = clientID,
              let contactID = contactID else {
            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
            return
        }
        
        // Prepare individual record data
        let recordDict: [String: Any] = [
            "Address": "",
            "BillDate": record.billDate,
            "CandId": record.candID,
            "CheckIn": selectedStartTimes[record.checkIn]  ?? record.checkIn,
            "CheckOut": selectedEndTimes[record.checkOut] ?? record.checkOut,
            "ClientId": clientID,
            "ContactId": contactID,
            "EndTime": record.endTime,
            "IPAddress": getIPv4Address() ?? "",
            "Id": record.id,
            "Name": record.candidateName ?? "",
            "OrderId": record.orderID,
            "PayforBreak": record.payforBreak,
            "ReasonId": record.reasonID,
            "ReasonType": selectedReasons[record.id]?.rawValue ?? "",
            "ReasonComment": reasonComments[record.id] ?? "",
            "RecCode": record.recCode,
            "RouteName": "iOS",
            "StartTime": record.startTime,
            "Type": 0,
            "WeekEnd": record.weekEnd,
            "breakMinutes": record.breakMinutes,
            "latitude": "",
            "longitude": "",
            "timeIn": "1900-01-01 00:00:00",
            "timeOut": "1900-01-01 00:00:00",
            "totlaHours": record.totalHours
        ]
        guard let start = startSelectedTime,
              let end = endSelectedTime else {
            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
            return
        }
        // Call API to save individual record
        viewModel.saveRecordDetails(response: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), checkin: "\(start ??  record.checkIn)", checkout: "\(end ?? record.checkOut)", note: "", errorHandler: errorHandler)
        
        
//        saveIndividualRecord(
//            params: recordDict,
//            recordId: record.id,
//            errorHandler: errorHandler
//        )
        
        print("Saving individual record: \(record.id)")
        print("Record data: \(recordDict)")
    }

    private func deleteIndividualRecord(_ record: ECheckInAllResponse, clientID:Int, contactID:Int) {
        guard record.isSubmitted == 0 else {
            errorHandler.showError(message: "Cannot delete submitted record", mode: .toast)
            return
        }
        
//        guard let clientID = clientID,
//              let contactID = contactID else {
//            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
//            return
//        }
        
        // Prepare delete parameters
        let deleteParams: [String: Any] = [
            "CandId": record.candID,
            "OrderId": record.orderID,
            "WeekEnd": record.weekEnd,
            "BillDate": record.billDate,
            "StartTime": record.startTime,
            "EndTime": record.endTime,
            "CheckIn": record.checkIn,
            "CheckOut": record.checkOut,
            "Id": record.id,
            "breakMinutes": record.breakMinutes,
            "totlaHours": record.totalHours,
            "IPAddress": getIPv4Address() ?? "Not Found",
            "ClientId": clientID,
            "ContactId": contactID,
            "ReasonType": selectedReasons[record.id]?.rawValue ?? "",
            "ReasonComment": reasonComments[record.id] ?? ""
        ]
        
        // Call API to delete record
        viewModel.deleteRecords(
            responseData: record,
            contactId: String(contactID ?? 0),
            clientId: String(clientID ?? 0),
            errorHandler: errorHandler
        )
        
        // Remove from local selections if it was selected
        if checkboxManager.isSelected(record.id) {
            checkboxManager.removeRecord(record)
        }
        
        print("Deleting individual record: \(record.id)")
        print("Delete params: \(deleteParams)")
    }
    
    private var saveAlertOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showSaveAlert = false
                }
            
            VStack {
                AlertView(
                    image: Image(systemName: "exclamationmark.circle.fill"),
                    title: "Save Record",
                    message: "Are you sure you want to Save this record for \(activeRecordForSave?.candidateName ?? "this candidate")?",
                    primaryButton: AlertButtonConfig(title: "Save", action: {
                        if let recordToDelete = activeRecordForSave {
                        saveIndividualRecord(recordToDelete)
                        }
                        showSaveAlert = false
                        activeRecordForSave = nil
                    }),
                    secondaryButton: AlertButtonConfig(title: "Cancel", action: {
                        showSaveAlert = false
                        activeRecordForSave = nil
                    }),
                    dismiss: {
                        showSaveAlert = false
                        activeRecordForSave = nil
                    }
                )
            }
        }
        .zIndex(10)
    }
    

}

// MARK: - Preview
struct ECheckin_View_Previews: PreviewProvider {
    static var previews: some View {
        ECheckin_View(clientID: 1, contactID: 1)
            .environmentObject(GlobalErrorHandler())
    }
}


import SwiftUI
import Foundation

extension String {
    /// Converts "yyyy-MM-dd'T'HH:mm:ss" to time with AM/PM
    func toTimeAMPM(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"   // Example: "8:00 AM"
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        return outputFormatter.string(from: date)
    }
}






// MARK: - Checkbox Manager
class CheckboxManager: ObservableObject {
    @Published var selectedRecords: Set<Int> = []
    @Published var submissionArray: [[String: Any]] = []
    var extraFields: [String: Any] = [:]
    @StateObject private var locationDataManager = LocationDataManager()
    @State var startSelectedTime:String?
    @State var endSelectedTime:String?
    var clientid:Int = 0
    var contactid:Int = 0
   // let division: DivisionList
    func toggleRecord(_ record: ECheckInAllResponse) {
        if selectedRecords.contains(record.id) {
            // Remove from selection and submission array
            removeRecord(record)
        } else {
            // Add to selection and submission array
            addRecord(record, extraFields: extraFields)
        }
    }
    
    private func addRecord(_ record: ECheckInAllResponse, extraFields: [String: Any])  {
        selectedRecords.insert(record.id)
        
        //        let recordDict: [String: Any] = [
        //            "CandId": record.candID,
        //            "CandidateName": record.candidateName ?? "",
        //            "OrderId": record.orderID,
        //            "WeekEnd": record.weekEnd,
        //            "BillDate": record.billDate,
        //            "StartTime": record.startTime,
        //            "EndTime": record.endTime,
        //            "CheckIn": record.checkIn,
        //            "CheckOut": record.checkOut,
        //            "TxnType": record.txnType,
        //            "RouteName": "iOS",
        //            "TotalHours": record.totalHours,
        //            "RoundedTotalHours": record.roundedTotalHours,
        //            "BreakMinutes": record.breakMinutes,
        //            "RecCode": record.recCode,
        //            "PayforBreak": record.payforBreak,
        //            "Position": record.position,
        //            "ISAdminUser": record.isAdminUser,
        //            "Status": record.status,
        //            "Id": record.id,
        //            "ReasonId": record.reasonID,
        //            "ReasonForTimeChange": record.reasonForTimeChange ?? "",
        //            "AdditionalComments": record.additionalComments ?? "",
        //            "IsSubmitted": record.isSubmitted,
        //            "OtherReason": record.otherReason ?? "",
        //            "PositionLabelColor": record.positionLabelColor,
        //            "ReportTo": record.reportTo ?? "",
        //            "Rating": record.rating ?? 0,
        //            "RatingComments": record.ratingComments ?? ""
        //        ]
       
        
        
        do{
            //            let coordinate = try await locationManager.getLocation()
            //            print("✅ Got location: \(coordinate.latitude), \(coordinate.longitude)")
            //            let address = try await locationManager.getAddress()
            var recordDict :[String:Any] =  [
                "CandId":record.candID, "OrderId":record.orderID, "WeekEnd":record.weekEnd, "BillDate":record.billDate, "StartTime":record.startTime, "EndTime": record.endTime, "CheckIn": startSelectedTime ?? record.checkIn, "CheckOut": endSelectedTime ?? record.checkOut, "Type":0, "RouteName":"iOS", "ClientId":clientid, "ContactId":contactid, "timeOut":"1900-01-01 00:00:00", "timeIn":"1900-01-01 00:00:00", "breakMinutes":record.breakMinutes, "totlaHours":record.totalHours, "RecCode":record.recCode, "PayforBreak":0, "Id":record.id, "longitude":locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0, "latitude": locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0, "Address":locationDataManager.currentAddress ?? "2/91/20, Green Fields Road, Hyderabad, India", "Name":record.candidateName, "ReasonId":record.reasonID, "IPAddress":getIPv4Address() ?? ""
            ]
            // Merge in the extra keys, allowing extraFields to overwrite on conflict
                recordDict = recordDict.merging(extraFields) { _, new in new }
            
            if record.isSubmitted == 0 {
                submissionArray.append(recordDict)
            }
            print("Added record \(record.id) to submission array. Total count: \(submissionArray.count)")
        }catch{
        }
    }
    
    func removeRecord(_ record: ECheckInAllResponse) {
        selectedRecords.remove(record.id)
        submissionArray.removeAll { dict in
            if let dictId = dict["Id"] as? Int {
                return dictId == record.id
            }
            return false
        }
        print("Removed record \(record.id) from selection. Total count: \(submissionArray.count)")
    }
    
    func isSelected(_ recordId: Int) -> Bool {
        return selectedRecords.contains(recordId)
    }
    
    func clearAll() {
        selectedRecords.removeAll()
        submissionArray.removeAll()
        print("Cleared all selections")
    }
    
    func getSubmissionData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: submissionArray, options: .prettyPrinted)
            print("Generated JSON data for \(submissionArray.count) records")
            return jsonData
        } catch {
            print("Error creating JSON data: \(error)")
            return nil
        }
    }
    
    var hasSelectedRecords: Bool {
        return !selectedRecords.isEmpty
    }
    
    var selectedCount: Int {
        return selectedRecords.count
    }
}


//extension ECheckVM {
//    func saveIndividualRecord(params: [String: Any], recordId: Int, errorHandler: GlobalErrorHandler) {
//        // Implement your API call for saving individual record
//        // This should call your save endpoint with the individual record data
//        
//        // Example implementation:
//        Task {
//            do {
//                // Make your API call here
//                // let response = try await APIService.saveRecord(params: params)
//                
//                // Handle success
//                DispatchQueue.main.async {
//                    // Update the record status in your data array
//                    if let index = self.echeckallData.firstIndex(where: { $0.id == recordId }) {
//                        self.echeckallData[index].isSubmitted = 1
//                    }
//                  // saveRecordDetails(response: , contactId: <#T##String#>, clientId: <#T##String#>, errorHandler: <#T##GlobalErrorHandler#>)
//                    
//                    // Show success message
//                    self.showAlert = true
//                    self.alertMessage = "Record saved successfully"
//                    self.alertType = .success
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    errorHandler.showError(message: "Failed to save record: \(error.localizedDescription)", mode: .toast)
//                }
//            }
//        }
//    }
//    
//    func deleteIndividualRecord(params: [String: Any], recordId: Int, errorHandler: GlobalErrorHandler) {
//        // Implement your API call for deleting individual record
//        Task {
//            do {
//                // Make your API call here
//                // let response = try await APIService.deleteRecord(params: params)
//                
//                // Handle success
//                DispatchQueue.main.async {
//                    // Remove the record from your data array
//                    self.echeckallData.removeAll { $0.id == recordId }
//                    
//                    // Show success message
//                    self.showAlert = true
//                    self.alertMessage = "Record deleted successfully"
//                    self.alertType = .success
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    errorHandler.showError(message: "Failed to delete record: \(error.localizedDescription)", mode: .toast)
//                }
//            }
//        }
//    }
//}
