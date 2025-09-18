//
//  Echeckin_View.swift
//  IntelliStaff_CMA
//
//  Created by ios on 14/08/25.
//
import SwiftUI
import SSDateTimePicker
//
enum ActiveAlert {
    case feedback
    case info
}


//
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



//
//struct OverAllUI: View {
//    @State private var showTimePicker = false
//    @State private var selectedDate: Date = Date()
//    @State private var userRating = 0
//    @State private var showFeedbackAlert = false
//    @State private var feedbackText = ""
//    @State private var startDate: Date? = Date()
//    @State private var tappedDate: Date? = Date()
//    @State private var startTime: Time? = Time()
//    @State private var isChecked: Bool = false
//    @State private var showDatePicker = false
//    @State private var showAlert = false
//    @State private var activeItemID: UUID? = nil
//    @State private var activeTime: Time = Time()
//    @State private var selectedTimes: [UUID: Time] = [:]
//    @State private var activeTimeType: TimeType = .start
//    @State private var activeRecordKey: String = ""
//    @State private var showDeleteAlert = false
//    @State private var showSaveAlert = false
//    @State private var showFeedBackAlert = false
//    @State private var activeAlert: ActiveAlert?
//    @State private var showLogoutAlert = false
//    @State private var savedRemark: String = ""
//    @State private var selectedStartTimes: [String: Time] = [:]
//    @State private var selectedEndTimes: [String: Time] = [:]
//    var totalSelected: [ECheckInAllResponse] = []
//    var notValidArrayList: [[String:Any]] = []
//    @State private var showSaveAlertWithNote = false
//    @State private var noteText: String = ""
//    @State private var activeRecordForDeletion: ECheckInAllResponse? = nil
//    @State private var deleteCandidateName: String = ""
//    // New dropdown states
//    @State private var showReasonDropdown: [Int: Bool] = [:]
//    @State private var selectedReasons: [Int: ReasonType] = [:]
//    @State private var reasonComments: [Int: String] = [:]
//    @State private var showReasonAlert = false
//    @State private var activeReasonRecordID = 0
//    @State private var tempReasonComment = ""
//    @State private var alertTitle = ""
//   @State private var alertTitleColor: Color = .black
//   @State private var alertTitleBg: Color = .white
//   @State private var buttonBg: Color = .blue
//   @State private var buttonTitleColor: Color = .white
//    @State private var textFieldAlert: TextFieldAlert?
//    // MARK: - Add state variable for delete confirmation
//    @State private var activeRecordForSave: ECheckInAllResponse? = nil
//    let clientID: Int?
//    let contactID: Int?
//    @State private var startSelectedTime:String? = ""
//    @State private var endSelectedTime:String? = ""
//    @StateObject private var checkboxManager = CheckboxManager()
//    @State var viewModel = OverallVM()
//    @EnvironmentObject var errorHandler: GlobalErrorHandler
//    @State private var items: [AllItem] = []
//
//    var isSubmitEnabled: Bool {
//        checkboxManager.submissionArray.count > 1
//    }
//
//    var canSave: Bool {
//        guard let res = viewModel.echeckallData.first else { return false }
//        return res.isSubmitted == 0   // enabled only if not submitted
//    }
//
//    var canDelete: Bool {
//        guard let res = viewModel.echeckallData.first else { return false }
//        return res.isSubmitted == 0   // enabled only if not submitted
//    }
//
//
//
//
//    var isreasonSubmitEnabled:Bool = false
//
//    var body: some View {
//        ZStack {
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
//
//            mainContentView
//            overlayViews
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.bottom, 100) // extra safe space for last element
//        .onAppear {
//            handleViewAppear()
//        }
//
//        if viewModel.isLoading {
//            Color.black.opacity(0.5)
//                .ignoresSafeArea()
//
//            TriangleLoader()
//        }
//
//        // Alert handling
//        if viewModel.showAlert, let message = viewModel.alertMessage {
//            if viewModel.alertType == .success {
//                AlertView(
//                    title: "EMA 2.0",
//                    message: message,
//                    primaryButton: AlertButtonConfig(title: "OK") {
//                        viewModel.showAlert = false
//                    },
//                    dismiss: {
//                        viewModel.showAlert = false
//                    },
//                    alertType: .success
//                )
//            }else {
//                AlertView(
//                    title: "EMA 2.0",
//                    message: message,
//                    primaryButton: AlertButtonConfig(title: "Retry") {
//                        if let firstItem = viewModel.echeckallData.first,
//                           let clientID = clientID,
//                           let contactID = contactID {
//                        }
//                        viewModel.showAlert = false
//                    },
//                    secondaryButton: AlertButtonConfig(title: "Cancel") {
//                        viewModel.showAlert = false
//                    },
//                    dismiss: {
//                        viewModel.showAlert = false
//                    },
//                    alertType: .error
//                )
//            }
//        }
//    }
//
//    // MARK: - Main Content View
//    private var mainContentView: some View {
//        VStack(spacing: 0) {
//            headerSection
//            recordsScrollView
//        }
//    }
//
//    // MARK: - Header Section
//    private var headerSection: some View {
//        VStack(spacing: 6) { // reduced spacing
//            dateAndGoSection
//            submitAndInfoSection
//        }
//        .padding(.horizontal, 12) // tighter padding
//        .padding(.vertical, 4)    // reduced height
//        .background(Color(.systemGroupedBackground))
//    }
//
//    // MARK: - Date and Go Section
//    private var dateAndGoSection: some View {
//        HStack(spacing: 6) { // tighter spacing
//            datePickerButton
//            goButton
//        }
//    }
//
//    private var datePickerButton: some View {
//        Button(action: {
//            showDatePicker = true
//        }) {
//            HStack(spacing: 6) {
//                Text(datePickerText)
//                    .foregroundColor(startDate == nil ? Color(.systemGray) : Color(.label))
//                    .font(.system(size: 16, weight: .medium)) // smaller font
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//                Image(systemName: "calendar")
//                    .foregroundColor(Color(.theme))
//                    .font(.system(size: 16)) // medium icon
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8) // reduced height
//            .background(Color.init(hex: "#778da9"))
//            .cornerRadius(8) // slightly smaller radius
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.systemGray4), lineWidth: 1)
//            )
//        }
//    }
//
//    private var goButton: some View {
//        Button("Go") {
//            guard let clientID = clientID,
//                  let contactID = contactID else {
//                print("❌ Missing clientID or contactID")
//                errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
//                return
//            }
//            if let startDate = tappedDate {
//                viewModel.echeckallData.removeAll()
//                viewModel.fetchOverallDetails(
//                    contactId: "\(contactID)",
//                    clientId: "\(clientID)",
//                    weekEnd: Date_Time_Formatter.APIformatDate(startDate),
//                    errorHandler: errorHandler
//                )
//            }
//        }
//        .font(.system(size: 16, weight: .semibold)) // medium font
//        .foregroundColor(.white)
//        .padding(.horizontal, 18)
//        .padding(.vertical, 8) // reduced height
//        .background(Color(hex: "#111184"))
//        .cornerRadius(8)
//    }
//
//    // MARK: - Submit and Info Section
//    private var submitAndInfoSection: some View {
//        HStack {
//            Spacer()
//            submitButton
//            Spacer()
//            infoButton
//        }
//    }
//
//    private var submitButton: some View {
//        Button("Submit") {
//            print("Got the Submission Array ------- \(checkboxManager.submissionArray)")
//            viewModel.overallSubmit(params: checkboxManager.submissionArray, errorHandler: errorHandler)
//        }
//        .disabled(checkboxManager.submissionArray.isEmpty)
//        .font(.system(size: 13, weight: .semibold)) // medium font
//        .foregroundColor(!checkboxManager.submissionArray.isEmpty ? .white : Color(.systemGray2))
//        .padding(.horizontal, 20)
//        .padding(.vertical, 8) // reduced height
//        .background(!checkboxManager.submissionArray.isEmpty ? Color(hex: "#111184") : Color(.systemGray5))
//        .cornerRadius(8)
//    }
//
//
//
//    private var datePickerText: String {
//        if let startDate = startDate {
//            return Date_Time_Formatter.formattedDate(startDate)
//        } else {
//            return "Enter Date"
//        }
//    }
//
//    private var infoButton: some View {
//        Button(action: {
//            withAnimation {
//                showAlert.toggle()
//            }
//        }) {
//            Image(systemName: "info.circle.fill")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.systemGray3))
//        }
//    }
//
//    // MARK: - Records ScrollView
//    private var recordsScrollView: some View {
//        ScrollView {
//            LazyVStack(spacing: 12) {
//                ForEach(viewModel.echeckallData.indices, id: \.self) { index in
//                    recordCardView(
//                        record: viewModel.echeckallData[index],
//                        index: index
//                    )
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 8)
//        }
//    }
//
//    // MARK: - Record Card View
//
//    // MARK: - Record Header with Checkbox
//    private func recordHeaderView(record: ECheckInAllResponse) -> some View {
//        HStack {
//            Text(record.candidateName ?? "Unknown")
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.primary)
//
//            Circle()
//                .fill(record.isSubmitted == 1 ? Color.green : Color.orange)
//                .frame(width: 8, height: 8)
//
//            Spacer()
//
//            // Checkbox Button
//            Button(action: {
//                withAnimation(.easeInOut(duration: 0.2)) {
//                    // Wrap async call in Task
//                    checkboxManager.clientid = clientID ?? 0
//                    checkboxManager.contactid = contactID ?? 0
//                    checkboxManager.startSelectedTime = startSelectedTime ?? ""
//                    checkboxManager.endSelectedTime = endSelectedTime ?? ""
//                    checkboxManager.toggleRecord(record)
//
//                }
//            }) {
//                Image(systemName: checkboxManager.isSelected(record.id) ? "checkmark.square.fill" : "square")
//                    .font(.system(size: 20))
//                    .foregroundColor(checkboxManager.isSelected(record.id) ? .blue : Color(.systemGray3))
//            }
//        }
//    }
//
//    // MARK: - Record Card View
//    private func recordCardView(record: ECheckInAllResponse, index: Int) -> some View {
//        VStack(alignment: .leading, spacing: 16) {
//            recordHeaderView(record: record)
//            recordDetailsView(record: record)
//            timePickersView(for: record)
//            reasonDropdownView(for: record, reason: .arriveLate,comment: "")
//            recordActionsView(for: record)
//           // recordActionsView
//        }
//        .padding(16)
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
//        .alert("Enter Remark", isPresented: $showFeedbackAlert, presenting: activeAlert) { alertType in
//            if alertType == .feedback {
//                TextField("Enter your remark", text: $feedbackText)
//                Button("Submit") {
//                    savedRemark = feedbackText
//                    print("User feedback: \(savedRemark)")
//                    viewModel.fetchFeedbackDeatils(
//                        clientId: "\(clientID ?? 0)",
//                        weekEnd: viewModel.echeckallData[index].weekEnd,
//                        rating: String(userRating),
//                        source: String(userRating),
//                        CandId: "\(viewModel.echeckallData[index].candID)",
//                        OrderId: "\(viewModel.echeckallData[index].orderID)",
//                        comments: feedbackText,
//                        ClientContacts: String(contactID ?? 0),
//                        errorHandler: errorHandler
//                    )
//                    feedbackText = ""
//                }
//                Button("Cancel", role: .cancel) { }
//            } else if alertType == .info {
//                Button("OK", role: .cancel) { }
//            }
//        } message: { alertType in
//            if alertType == .info {
//                Text(savedRemark.isEmpty ? "No feedback yet" : savedRemark)
//            }
//        }
//        .alert("Add Comment", isPresented: $showReasonAlert) {
//            TextField("Enter comment for irregular hours", text: $tempReasonComment)
//            Button("Save Reason") {
//                reasonComments[activeReasonRecordID] = tempReasonComment
//
//                if let record = viewModel.echeckallData.first(where: { $0.id == activeReasonRecordID }),
//                   let selectedReason = selectedReasons[activeReasonRecordID] {
//                    viewModel.selectReasonDetails(
//                        responseData: record,
//                        reasonID: record.id,
//                        reasonType: selectedReason.rawValue,
//                        reasonComment: tempReasonComment,
//                        ClientId: clientID ?? 0,
//                        ContactId: contactID ?? 0,
//                        errorHandler: errorHandler
//                    )
//                }
//
//                tempReasonComment = ""
//                print("Reason saved with comment: \(reasonComments[activeReasonRecordID] ?? "")")
//            }
//            Button("Cancel", role: .cancel) {
//                tempReasonComment = ""
//            }
//        } message: {
//            Text("Please provide additional details for the selected reason.")
//        }
//
//    }
//
//    // MARK: - New Reason Dropdown View
//    private func reasonDropdownView(for record: ECheckInAllResponse, reason: ReasonType, comment: String) -> some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            HStack(spacing: 12) {
//                // Dropdown Button
//                Button(action: {
//                    withAnimation(.easeInOut(duration: 0.2)) {
//                        let recordID = record.id
//                        showReasonDropdown[recordID] = !(showReasonDropdown[recordID] ?? false)
//                    }
//                }) {
//                    HStack(spacing: 8) {
//                        Text(selectedReasons[record.id]?.displayName ?? "Reason For Irregular Hours")
//                            .foregroundColor(selectedReasons[record.id] != nil ? Color(.label) : Color(.systemGray))
//                            .font(.system(size: 14))
//                            .frame(maxWidth: .infinity, alignment: .center)
//
//                        Image(systemName: showReasonDropdown[record.id] == true ? "chevron.up" : "chevron.down")
//                            .foregroundColor(Color(.systemGray2))
//                            .font(.system(size: 12, weight: .medium))
//                    }
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 10)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color(.systemGray4), lineWidth: 1)
//                    )
//                }
//                .disabled(record.isSubmitted == 1) // 🔒 Disable dropdown when submitted
//                .opacity(record.isSubmitted == 1 ? 0.5 : 1) // Greyed out
//
//
//                // Save Reason Button
//                Button(action: {
//                    if record.isSubmitted == 0 {
//                        viewModel.selectReasonDetails(
//                            responseData: record,
//                            reasonID: record.id,
//                            reasonType: reason.rawValue,
//                            reasonComment: comment,
//                            ClientId: clientID ?? 0,
//                            ContactId: contactID ?? 0,
//                            errorHandler: errorHandler
//                        )
//                    }
//                }) {
//                    Image(systemName: record.isSubmitted == 1 ? "lock.fill" : "square.and.arrow.down")
//                        .foregroundColor(record.isSubmitted == 1 ? .gray : .green)
//                        .font(.system(size: 16))
//                        .frame(width: 32, height: 32)
//                        .background(
//                            (record.isSubmitted == 1 ? Color.gray.opacity(0.2) : Color.green.opacity(0.1))
//                        )
//                        .cornerRadius(6)
//                }
//                .disabled(record.isSubmitted == 1) // 🔒 Disable save button
//            }
//
//            // Dropdown Menu
//            if showReasonDropdown[record.id] == true && record.isSubmitted == 0 {
//                VStack(spacing: 0) {
//                    ForEach(ReasonType.allCases, id: \.self) { reason in
//                        Button(action: {
//                            selectedReasons[record.id] = reason
//                            withAnimation(.easeInOut(duration: 0.2)) {
//                                showReasonDropdown[record.id] = false
//                            }
//
//                            if reason == .other {
//                                activeReasonRecordID = record.id
//                                showReasonAlert = true
//                            }
//                        }) {
//                            HStack {
//                                Text(reason.displayName)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(Color(.label))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                                if selectedReasons[record.id] == reason {
//                                    Image(systemName: "checkmark")
//                                        .foregroundColor(.blue)
//                                        .font(.system(size: 12, weight: .medium))
//                                }
//                            }
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 12)
//                        }
//                        .background(Color.white)
//
//                        if reason != ReasonType.allCases.last {
//                            Divider()
//                                .padding(.leading, 12)
//                        }
//                    }
//                }
//                .background(Color.white)
//                .cornerRadius(8)
//                .shadow(color: Color(.systemGray4).opacity(0.3), radius: 3, x: 0, y: 2)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color(.systemGray4), lineWidth: 1)
//                )
//            }
//        }
//    }
//
//
//    // MARK: - Star Rating Section
//    private var starRatingSection: some View {
//           HStack(spacing: 2) {
//               StarRatingView(rating: $userRating) { newRating in
//                   if newRating <= 2 {
//                       activeAlert = .feedback
//                       showFeedbackAlert = true
//                   }
//               }
//
//               Button {
//                   activeAlert = .info
//                   showFeedbackAlert = true
//               } label: {
//                   Image(systemName: "info.circle")
//                       .foregroundColor(.gray)
//                       .padding(.leading, 4)
//               }
//           }
//           .padding(.vertical, 8)
//       }
//
//    // MARK: - Time Picker Button
//    private func timePickerButton(for record: ECheckInAllResponse, timeType: TimeType, placeholder: String) -> some View {
//        Button(action: {
//            switch timeType {
//            case .start:
//                activeRecordKey = record.checkIn
//            case .end:
//                activeRecordKey = record.checkOut
//            }
//            activeTimeType = timeType
//            showTimePicker = true
//        }) {
//            HStack(spacing: 8) {
//                Text(timePickerText(for: record, timeType: timeType, placeholder: placeholder))
//                    .foregroundColor(getSelectedTime(for: record, timeType: timeType) == nil ? Color(.black) : Color(.label))
//                    .font(.system(size: 14, weight: .medium))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                Image(systemName: "clock.fill")
//                    .foregroundColor(Color(.theme))
//                    .font(.system(size: 14))
//            }
//            .padding(.horizontal, 12)
//            .padding(.vertical, 10)
//            .background(Color.init(hex: "#778da9"))
//            .cornerRadius(8)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.systemBlue), lineWidth: 1)
//            )
//        }
//    }
//
//    private func timePickerText(for record: ECheckInAllResponse, timeType: TimeType, placeholder: String) -> String {
//        if let selectedTime = getSelectedTime(for: record, timeType: timeType) {
//            return Date_Time_Formatter.formatTime(selectedTime)
//        } else {
//            return placeholder
//        }
//    }
//
//    private func getSelectedTime(for record: ECheckInAllResponse, timeType: TimeType) -> Time? {
//        switch timeType {
//        case .start:
//            return selectedStartTimes[record.checkIn]
//        case .end:
//            return selectedEndTimes[record.checkOut]
//        }
//    }
//
//    // MARK: - Record Header
//    private mutating func recordHeaderView(record: ECheckInAllResponse, index: Int) -> some View {
//        HStack {
//            Text(record.candidateName ?? "")
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(Color(.label))
//
//            Circle()
//                .fill(Color.yellow)
//                .frame(width: 8, height: 8)
//
//            Spacer()
//           // checkboxButton(record: record, index: index)
//        }
//    }
//
//    // MARK: - Submit Section
//    private var submitSection: some View {
//        VStack(spacing: 12) {
//            if checkboxManager.hasSelectedRecords {
//                HStack {
//                    Text("Ready to submit \(checkboxManager.selectedCount) record(s)")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//
//                    Spacer()
//
//                    Button("View JSON") {
//                        if let jsonData = checkboxManager.getSubmissionData(),
//                           let jsonString = String(data: jsonData, encoding: .utf8) {
//                            print("JSON Data:\n\(jsonString)")
//                        }
//                    }
//                    .font(.caption)
//                    .foregroundColor(.blue)
//                }
//                .padding(.horizontal, 16)
//            }
//
//            HStack(spacing: 16) {
//                Button("Submit Selected") {
//                    submitSelectedRecords()
//                }
//                .disabled(!checkboxManager.hasSelectedRecords)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 14)
//                .background(checkboxManager.hasSelectedRecords ? Color.blue : Color(.systemGray4))
//                .cornerRadius(10)
//
//                Button("Debug") {
//                    debugSubmissionArray()
//                }
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(.blue)
//                .frame(width: 80)
//                .padding(.vertical, 14)
//                .background(Color(.systemBackground))
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.blue, lineWidth: 1)
//                )
//            }
//            .padding(.horizontal, 16)
//            .padding(.bottom, 16)
//        }
//        .background(Color(.systemGroupedBackground))
//    }
//
//    // MARK: - Helper Methods
////    private func handleViewAppear() {
////        // Load initial data
////        print("View appeared - loading initial data")
////
////    }
//
//    private func submitSelectedRecords() {
//        guard checkboxManager.hasSelectedRecords else { return }
//
//        if let jsonData = checkboxManager.getSubmissionData() {
//            print("Submitting \(checkboxManager.selectedCount) records")
//
//            // Your API submission logic here
//            // Example: viewModel.submitRecords(jsonData: jsonData)
//
//            // Clear selections after successful submission
//            checkboxManager.clearAll()
//        }
//    }
//
//    private func debugSubmissionArray() {
//        print("\n=== DEBUG SUBMISSION ARRAY ===")
//        print("Selected IDs: \(checkboxManager.selectedRecords)")
//        print("Array count: \(checkboxManager.submissionArray.count)")
//
//        for (index, dict) in checkboxManager.submissionArray.enumerated() {
//            print("\nRecord \(index + 1):")
//            print("  ID: \(dict["Id"] ?? "N/A")")
//            print("  Name: \(dict["CandidateName"] ?? "N/A")")
//            print("  Total Hours: \(dict["TotalHours"] ?? "N/A")")
//        }
//
//        if let jsonData = checkboxManager.getSubmissionData(),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            print("\nJSON Output:\n\(jsonString)")
//        }
//        print("=== END DEBUG ===\n")
//    }
//
//
//
//    // MARK: - Record Details
//    private func recordDetailsView(record: ECheckInAllResponse) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            starRatingSection
//            positionView(record: record)
//            scheduleTimeView(record: record)
//            totalHoursView(record: record)
//            breakMinutesView(record: record)
//        }
//    }
//
//    // MARK: - Record Actions
//    private func recordActionsView(for record: ECheckInAllResponse) -> some View {
//        HStack {
//            deleteButton(for: record)
//            Spacer()
//            saveButton(for: record)
//        }
//        .padding(.top, 8)
//    }
//
//    private func deleteButton(for record: ECheckInAllResponse) -> some View {
//        Button(action: {
//            // Set the active record for deletion confirmation
//            activeRecordForDeletion = record
//            deleteCandidateName = record.candidateName ?? "this candidate"
//            showDeleteAlert = true
//        }) {
//            Image(systemName: "trash.fill")
//                .font(.system(size: 16))
//                .foregroundColor(.red)
//                .frame(width: 32, height: 32)
//                .background(Color.red.opacity(0.1))
//                .cornerRadius(6)
//        }
//       // .disabled(record.isSubmitted == 1) // Disable if already submitted
//        .disabled(record.isSubmitted == 1) // Disable if already submitted
//        .opacity(record.isSubmitted == 1 ? 0.5 : 1.0)
//        .alert("Delete Record",
//               isPresented: $showDeleteAlert,
//               presenting: activeRecordForDeletion) { record in
//            Button("Delete", role: .destructive) {
//               // deleteIndividualRecord(record, clientID: clientID ?? 0, contactID: contactID ?? 0)
//                viewModel.deleteRecords(responseData: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), errorHandler: errorHandler)
//                activeRecordForDeletion = nil
//            }
//            Button("Cancel", role: .cancel) {
//                activeRecordForDeletion = nil
//            }
//        } message: { record in
//            Text("Are you sure you want to delete this record for \(record.candidateName ?? "this candidate")?")
//        }
//    }
//
//    private func saveButton(for record: ECheckInAllResponse) -> some View {
//        Button(action: {
//            activeRecordForSave = record
//            textFieldAlert = TextFieldAlert(
//                title: "Save Record",
//                message: "Enter Reason for Changing Time",
//                placeholder: "Enter note..."
//            ) { note in
//                if let record = activeRecordForSave {
//                    viewModel.saveRecordDetails(
//                        response: record,
//                        contactId: String(contactID ?? 0),
//                        clientId: String(clientID ?? 0),
//                        checkin: record.checkIn,
//                        checkout: record.checkOut,
//                        note: note ?? "",
//                        errorHandler: errorHandler
//                    )
//
//                    viewModel.fetchOverallDetails(contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), weekEnd: DateFormatter().string(from: startDate ?? Date()), errorHandler: errorHandler)
//                }
//            }
//        }) {
//            Text("Save")
//                .font(.system(size: 14, weight: .medium))
//                .foregroundColor(.white)
//                .padding(.horizontal, 24)
//                .padding(.vertical, 8)
//                .background(record.isSubmitted == 1 ? Color(.systemGray4) : Color(hex: "#111184"))
//                .cornerRadius(8)
//        }
//        .disabled(record.isSubmitted == 1)
//        .opacity(record.isSubmitted == 1 ? 0.5 : 1.0)
//        .background(TextFieldWrapper(alert: $textFieldAlert).frame(width: 0, height: 0)) // invisible host
//    }
//
//
//    private func positionView(record: ECheckInAllResponse) -> some View {
//        HStack(spacing: 8) {
//            Text("Position:")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.systemGray))
//
//            Text(record.position)
//                .font(.system(size: 14, weight: .medium))
//                .foregroundColor(.white)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(Color(hex: record.positionLabelColor))
//                .cornerRadius(4)
//
//            Spacer()
//        }
//    }
//
//    private func scheduleTimeView(record: ECheckInAllResponse) -> some View {
//        HStack {
//            Text("Schedule Time:")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.systemGray))
//
//            Text("\(record.startTime.toTimeAMPM() ?? "") - \(record.endTime.toTimeAMPM() ?? "")")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.label))
//
//            Spacer()
//        }
//    }
//
//    private func totalHoursView(record: ECheckInAllResponse) -> some View {
//        HStack {
//            Text("Total Hours:")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.systemGray))
//
//            Text("\(record.totalHours)")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.label))
//
//            Spacer()
//        }
//    }
//
//    private func breakMinutesView(record: ECheckInAllResponse) -> some View {
//        HStack {
//            Text("Break Minutes:")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.systemGray))
//
//            Text("\(record.breakMinutes)")
//                .font(.system(size: 14))
//                .foregroundColor(Color(.label))
//
//            Spacer()
//        }
//    }
//
//    private func delete(record: ECheckInAllResponse) {
//        viewModel.deleteRecords(responseData: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), errorHandler: errorHandler)
//    }
//
//
//    // MARK: - Time Pickers
//    private var timePickerOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    showTimePicker = false
//                }
//
//            Custom_Timer(
//                showTimePicker: $showTimePicker,
//                selectedTime: $activeTime
//            ) { time in
//                switch activeTimeType {
//                case .start:
//                    selectedStartTimes[activeRecordKey] = time
//                    startSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
//                    print("Start time selected for record \(activeRecordKey): \(time)")
//                case .end:
//                    selectedEndTimes[activeRecordKey] = time
//                    endSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
//                    print("End time selected for record \(activeRecordKey): \(time)")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .zIndex(10)
//    }
//
//    // MARK: - Record Actions
//    private var recordActionsView: some View {
//        HStack {
//            trashButton
//            Spacer()
//            saveButton
//        }
//        .padding(.top, 8)
//    }
//
//    private var trashButton: some View {
//        Button(action: {
//            showDeleteAlert.toggle()
//        }) {
//            Image(systemName: "trash.fill")
//                .font(.system(size: 16))
//                .foregroundColor(.red)
//                .frame(width: 32, height: 32)
//                .background(Color.red.opacity(0.1))
//                .cornerRadius(6)
//        }
//    }
//
//    private var saveButton: some View {
//        Button(action: {
//            showSaveAlert.toggle()
//            // Add save action here with reason data
//        }) {
//            Text("Save")
//                .font(.system(size: 14, weight: .medium))
//                .foregroundColor(.white)
//                .padding(.horizontal, 24)
//                .padding(.vertical, 8)
//                .background(Color(.theme))
//                .cornerRadius(8)
//
//
//        }
//    }
//
//    // MARK: - Overlay Views
//    private var overlayViews: some View {
//        ZStack {
//            if showDatePicker {
//                datePickerOverlay
//            }
//
//            if showDeleteAlert {
//                deleteAlertOverlay
//            }
//
//            if showSaveAlert{
//                saveAlertOverlay
//            }
//
//            if showTimePicker {
//                timePickerOverlay
//            }
//
//            if showAlert {
//                CustomAlertView(show: $showAlert)
//            }
//        }
//    }
//
//    // MARK: - Date Picker Overlay
//    private var datePickerOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    showDatePicker = false
//                }
//
//            VStack {
//                Custom_Calander_View(
//                    showDatePicker: $showDatePicker,
//                    selectedDate: $selectedDate,
//                    onDateSelection: { date in
//                        selectedDate = date
//                        startDate = date
//                        tappedDate = date
//                        print("Start Date Selected: \(Date_Time_Formatter.formattedDate(date))")
//                        showDatePicker = false
//                    }
//                )
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .clipped()
//            }
//        }
//        .zIndex(10)
//    }
//
//    // Updated alert overlay:
//    private var deleteAlertOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    showDeleteAlert = false
//                }
//
//            VStack {
////                AlertView(
////                    image: Image(systemName: "exclamationmark.circle.fill"),
////                    title: "Delete Record",
////                    message: "Are you sure you want to delete this record for \(deleteCandidateName)?",
////                    primaryButton: AlertButtonConfig(title: "Delete", action: {
////                        if let recordToDelete = activeRecordForDeletion {
////                            deleteIndividualRecord(recordToDelete)
////                        }
////                        showDeleteAlert = false
////                        activeRecordForDeletion = nil
////                        deleteCandidateName = ""
////                    }),
////                    secondaryButton: AlertButtonConfig(title: "Cancel", action: {
////                        showDeleteAlert = false
////                        activeRecordForDeletion = nil
////                        deleteCandidateName = ""
////                    }),
////                    dismiss: {
////                        showDeleteAlert = false
////                        activeRecordForDeletion = nil
////                        deleteCandidateName = ""
////                    }
////                )
//            }
//        }
//        .zIndex(10)
//    }
//
//    // MARK: - Time Picker Overlay
//    private func timePickersView(for record: ECheckInAllResponse) -> some View {
//        HStack(spacing: 12) {
//            timePickerButton(
//                for: record,
//                timeType: .start,
//                placeholder: record.checkIn.toTimeAMPM() ?? "1:22 AM"
//            )
//
//            timePickerButton(
//                for: record,
//                timeType: .end,
//                placeholder: record.checkOut.toTimeAMPM() ?? "1:27 AM"
//            )
//        }
//    }
//
//    // MARK: - Helper Methods
//    private func handleViewAppear() {
//        guard let clientID = clientID,
//              let contactID = contactID else {
//            print("❌ Missing clientID or contactID")
//            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
//            return
//        }
//
//        viewModel.fetchOverallDetails(
//            contactId: "\(contactID)",
//            clientId: "\(clientID)",
//            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
//            errorHandler: errorHandler
//        )
//    }
//
//    private func saveReasonForRecord(_ record: ECheckInAllResponse) {
//        guard let selectedReason = selectedReasons[record.id] else {
//            errorHandler.showError(message: "Please select a reason first", mode: .toast)
//            return
//        }
//
//        if selectedReason == .other {
//            activeReasonRecordID = record.id
//            showReasonAlert = true
//        } else {
//            saveReasonToAPI(for: record, reason: selectedReason, comment: "")
//        }
//    }
//
//    private func saveReasonToAPI(for record: ECheckInAllResponse, reason: ReasonType, comment: String) {
//        let params: [String: Any] = [
//            "CandId": record.candID,
//            "OrderId": record.orderID,
//            "WeekEnd": record.weekEnd,
//            "BillDate": record.billDate,
//            "Id": record.id,
//            "ReasonType": reason.rawValue,
//            "ReasonComment": comment,
//            "ClientId": clientID ?? 0,
//            "ContactId": contactID ?? 0
//        ]
//
//        print("Saving reason for record \(record.id): \(reason.rawValue)")
//        print("API Params:", params)
//
//        viewModel.selectReasonDetails(
//            responseData: record,
//            reasonID: record.id,
//            reasonType: reason.rawValue,
//            reasonComment: comment,
//            ClientId: clientID ?? 0,
//            ContactId: contactID ?? 0,
//            errorHandler: errorHandler
//        )
//    }
//
//    private func deleteItem(_ items: [ECheckInAllResponse]) {
//        for item in items {
//            print("Delete button pressed for item \(item.id)")
//            let ipAddress = MobileNetworkInfo.getLocalIPAddress()
//            let params: [String: Any] = [
//                "CandId": item.candID,
//                "OrderId": item.orderID,
//                "WeekEnd": item.weekEnd,
//                "BillDate": item.billDate,
//                "StartTime": item.startTime,
//                "EndTime": item.endTime,
//                "CheckIn": item.checkIn,
//                "CheckOut": item.checkOut,
//                "Id": item.id,
//                "breakMinutes": item.breakMinutes,
//                "totlaHours": item.totalHours,
//                "IPAddress": ipAddress ?? "Not Found",
//                "ReasonType": selectedReasons[item.id]?.rawValue ?? "",
//                "ReasonComment": reasonComments[item.id] ?? ""
//            ]
//
//            print("Params for API call:", params)
//
//           // viewModel.deleteRecords(params: params, errorHandler: errorHandler)
//        }
//    }
//
//
//    private func showAlert(title: String, message: String) {
//        // Implementation for showing alerts
//    }
//
//    private func saveIndividualRecord(_ record: ECheckInAllResponse) {
//        guard record.isSubmitted == 0 else {
//            errorHandler.showError(message: "Record is already submitted", mode: .toast)
//            return
//        }
//
//        guard let clientID = clientID,
//              let contactID = contactID else {
//            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
//            return
//        }
//        let ipAddress = MobileNetworkInfo.getLocalIPAddress()
//        // Prepare individual record data
//        let recordDict: [String: Any] = [
//            "Address": "",
//            "BillDate": record.billDate,
//            "CandId": record.candID,
//            "CheckIn": selectedStartTimes[record.checkIn]  ?? record.checkIn,
//            "CheckOut": selectedEndTimes[record.checkOut] ?? record.checkOut,
//            "ClientId": clientID,
//            "ContactId": contactID,
//            "EndTime": record.endTime,
//            "IPAddress": ipAddress ?? "",
//            "Id": record.id,
//            "Name": record.candidateName ?? "",
//            "OrderId": record.orderID,
//            "PayforBreak": record.payforBreak,
//            "ReasonId": record.reasonID,
//            "ReasonType": selectedReasons[record.id]?.rawValue ?? "",
//            "ReasonComment": reasonComments[record.id] ?? "",
//            "RecCode": record.recCode,
//            "RouteName": "iOS",
//            "StartTime": record.startTime,
//            "Type": 0,
//            "WeekEnd": record.weekEnd,
//            "breakMinutes": record.breakMinutes,
//            "latitude": "",
//            "longitude": "",
//            "timeIn": "1900-01-01 00:00:00",
//            "timeOut": "1900-01-01 00:00:00",
//            "totlaHours": record.totalHours
//        ]
//        guard let start = startSelectedTime,
//              let end = endSelectedTime else {
//            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
//            return
//        }
//        // Call API to save individual record
//        viewModel.saveRecordDetails(response: record, contactId: String(contactID ?? 0), clientId: String(clientID ?? 0), checkin: "\(start ??  record.checkIn)", checkout: "\(end ?? record.checkOut)", note: "", errorHandler: errorHandler)
//
//
////        saveIndividualRecord(
////            params: recordDict,
////            recordId: record.id,
////            errorHandler: errorHandler
////        )
//
//        print("Saving individual record: \(record.id)")
//        print("Record data: \(recordDict)")
//    }
//
//    private func deleteIndividualRecord(_ record: ECheckInAllResponse, clientID:Int, contactID:Int) {
//        guard record.isSubmitted == 0 else {
//            errorHandler.showError(message: "Cannot delete submitted record", mode: .toast)
//            return
//        }
//        let ipAddress = MobileNetworkInfo.getLocalIPAddress()
//
////        guard let clientID = clientID,
////              let contactID = contactID else {
////            errorHandler.showError(message: "Missing client or contact information", mode: .toast)
////            return
////        }
//
//        // Prepare delete parameters
//        let deleteParams: [String: Any] = [
//            "CandId": record.candID,
//            "OrderId": record.orderID,
//            "WeekEnd": record.weekEnd,
//            "BillDate": record.billDate,
//            "StartTime": record.startTime,
//            "EndTime": record.endTime,
//            "CheckIn": record.checkIn,
//            "CheckOut": record.checkOut,
//            "Id": record.id,
//            "breakMinutes": record.breakMinutes,
//            "totlaHours": record.totalHours,
//            "IPAddress": ipAddress ?? "Not Found",
//            "ClientId": clientID,
//            "ContactId": contactID,
//            "ReasonType": selectedReasons[record.id]?.rawValue ?? "",
//            "ReasonComment": reasonComments[record.id] ?? ""
//        ]
//
//        // Call API to delete record
//        viewModel.deleteRecords(
//            responseData: record,
//            contactId: String(contactID ?? 0),
//            clientId: String(clientID ?? 0),
//            errorHandler: errorHandler
//        )
//
//        // Remove from local selections if it was selected
//        if checkboxManager.isSelected(record.id) {
//            checkboxManager.removeRecord(record)
//        }
//
//        print("Deleting individual record: \(record.id)")
//        print("Delete params: \(deleteParams)")
//    }
//
//    private var saveAlertOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    showSaveAlert = false
//                }
//
//            VStack {
//                AlertView(
//                    image: Image(systemName: "exclamationmark.circle.fill"),
//                    title: "Save Record",
//                    message: "Are you sure you want to Save this record for \(activeRecordForSave?.candidateName ?? "this candidate")?",
//                    primaryButton: AlertButtonConfig(title: "Save", action: {
//                        if let recordToDelete = activeRecordForSave {
//                        saveIndividualRecord(recordToDelete)
//                        }
//                        showSaveAlert = false
//                        activeRecordForSave = nil
//                    }),
//                    secondaryButton: AlertButtonConfig(title: "Cancel", action: {
//                        showSaveAlert = false
//                        activeRecordForSave = nil
//                    }),
//                    dismiss: {
//                        showSaveAlert = false
//                        activeRecordForSave = nil
//                    }
//                )
//            }
//        }
//        .zIndex(10)
//    }
//
//
//}
//
//// MARK: - Preview
//struct ECheckin_View_Previews: PreviewProvider {
//    static var previews: some View {
//        OverAllUI(clientID: 1, contactID: 1)
//            .environmentObject(GlobalErrorHandler())
//    }
//}
//
//
//import SwiftUI
//import Foundation
//
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
//
//
//
//
//
//
//// MARK: - Checkbox Manager
class CheckboxManager: ObservableObject {
    @Published var selectedRecords: Set<Int> = []
    @Published var submissionArray: [[String: Any]] = []
    var extraFields: [String: Any] = [:]
    private let locationDataManager = LocationDataManager()
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
        
        let ipAddress = MobileNetworkInfo.getLocalIPAddress()
        
        do{
            
            let checkReq = CheckInRequest(candId: record.candID, orderId: record.orderID, type: 3, weekEnd: record.weekEnd, clientId: clientid, timeOut: record.checkOut ?? "1900-01-01 00:00:00", totlaHours: Int(record.totalHours), recCode: "S", payForBreak: 0, latitude: String(locationDataManager.locationManager.location?.coordinate.latitude ?? 0.0), endTime: record.endTime, breakMinutes: record.breakMinutes, address: "\(locationDataManager.currentAddress ?? "")", checkIn: startSelectedTime ?? record.checkIn, retry: 0, contactId: contactid, longitude: String(locationDataManager.locationManager.location?.coordinate.longitude ?? 0.0), billDate: record.billDate, startTime: record.startTime, ipAddress: ipAddress ?? "", checkOut: endSelectedTime ?? record.checkOut, routeName: "iOS", timeIn:record.checkIn ?? "1900-01-01 00:00:00", id: record.id, ReasonId: record.reasonID, OtherReason: "\(String(record.otherReason ?? ""))")
            
            
            if let recordDict = checkReq.asDictionary() {
                // 🔎 Log request for debugging
                if let jsonData = try? JSONSerialization.data(withJSONObject: recordDict, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("📤 Request JSON:\n\(jsonString)")
                    if record.isSubmitted == 0 {
                        submissionArray.append(recordDict)
                    }
                    print("Added record \(record.id) to submission array. Total count: \(submissionArray.count)")
                }
            }
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

//class CheckboxManager: ObservableObject {
//    @Published var selectedRecords: Set<Int> = []
//    @Published var submissionArray: [[String: Any]] = []
//
//    var clientid: Int = 0
//    var contactid: Int = 0
//    var startSelectedTime: String?
//    var endSelectedTime: String?
//    var extraFields: [String: Any] = [:]
//
//    func isSelected(_ recordId: Int) -> Bool {
//        return selectedRecords.contains(recordId)
//    }
//
//    func toggleRecord(_ record: ECheckInAllResponse) {
//        if selectedRecords.contains(record.id) {
//            removeRecord(record.id)
//        } else {
//            addRecord(record, extraFields: extraFields)
//        }
//    }
//
//    func addRecord(_ record: ECheckInAllResponse, extraFields: [String: Any]) {
//        selectedRecords.insert(record.id)
//
//        // Create submission data
//        let submissionData: [String: Any] = [
//            "id": record.id,
//            "candidateName": record.candidateName ?? "",
//            "checkIn": record.checkIn,
//            "checkOut": record.checkOut,
//            "clientId": clientid,
//            "contactId": contactid,
//            "startSelectedTime": startSelectedTime ?? "",
//            "endSelectedTime": endSelectedTime ?? ""
//        ].merging(extraFields) { (_, new) in new }
//
//        submissionArray.append(submissionData)
//    }
//
//    func removeRecord(_ recordId: Int) {
//        selectedRecords.remove(recordId)
//        submissionArray.removeAll { item in
//            if let id = item["id"] as? Int {
//                return id == recordId
//            }
//            return false
//        }
//    }
//
//    func clearAll() {
//        selectedRecords.removeAll()
//        submissionArray.removeAll()
//    }
//}


import SwiftUI
import SSDateTimePicker

// MARK: - Configuration Models
struct ECheckinConfig {
    let clientID: Int?
    let contactID: Int?
    let initialDate: Date
    let canSubmit: Bool
    let canDelete: Bool
    let canSave: Bool
    
    init(clientID: Int?, contactID: Int?, initialDate: Date = Date(), canSubmit: Bool = true, canDelete: Bool = true, canSave: Bool = true) {
        self.clientID = clientID
        self.contactID = contactID
        self.initialDate = initialDate
        self.canSubmit = canSubmit
        self.canDelete = canDelete
        self.canSave = canSave
    }
}
struct RecordCardConfig {
    let showStarValue:Int?
    let showStarRating: Bool
    let showCheckbox: Bool
    let showReasonDropdown: Bool
    let showTimePickers: Bool
    let showActions: Bool
    let isEditable: Bool
    
    init(showStarRating: Bool = true, showCheckbox: Bool = true, showReasonDropdown: Bool = true, showTimePickers: Bool = true, showActions: Bool = true, isEditable: Bool = true) {
        self.showStarRating = showStarRating
        self.showCheckbox = showCheckbox
        self.showReasonDropdown = showReasonDropdown
        self.showTimePickers = showTimePickers
        self.showActions = showActions
        self.isEditable = isEditable
        self.showStarValue = 0
    }
}

// MARK: - Reusable Components

// 1. Header Component
struct ECheckinHeaderView: View {
    @Binding var selectedDate: Date?
    @Binding var showDatePicker: Bool
    let onGoButtonTap: () -> Void
    let onSubmitTap: () -> Void
    let onInfoTap: () -> Void
    let isSubmitEnabled: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                DatePickerButton(
                    selectedDate: $selectedDate,
                    showDatePicker: $showDatePicker
                )
                
                ActionButton(
                    title: "Go",
                    backgroundColor: Color(hex: "#111184"),
                    action: onGoButtonTap
                )
            }
            
            HStack {
                Spacer()
                
                ActionButton(
                    title: "Submit",
                    backgroundColor: isSubmitEnabled ? Color(hex: "#111184") : Color(.systemGray5),
                    textColor: isSubmitEnabled ? .white : Color(.systemGray2),
                    isEnabled: isSubmitEnabled,
                    action: onSubmitTap
                )
                
                Spacer()
                
                InfoButton(action: onInfoTap)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color(.systemGroupedBackground))
    }
}

// 2. Date Picker Button Component
struct DatePickerButton: View {
    @Binding var selectedDate: Date?
    @Binding var showDatePicker: Bool
    
    var body: some View {
        Button(action: { showDatePicker = true }) {
            HStack(spacing: 6) {
                Text(dateText)
                    .foregroundColor(selectedDate == nil ? Color(.systemGray) : Color(.label))
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "calendar")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(hex: "#778da9"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
    
    private var dateText: String {
        if let date = selectedDate {
            return Date_Time_Formatter.formattedDate(date)
        }
        return "Enter Date"
    }
}

// 3. Action Button Component
struct ActionButton: View {
    let title: String
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .disabled(!isEnabled)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(textColor)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

// 4. Info Button Component
struct InfoButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray3))
        }
    }
}

// 5. Record Card Component
struct RecordCardView: View {
    let record: ECheckInAllResponse
    let index: Int
    let config: RecordCardConfig
    @ObservedObject var checkboxManager: CheckboxManager
    
    // Bindings for interactive elements
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var userRating: Int
    @Binding var showTimePicker: Bool
    @Binding var activeTimeType: TimeType
    @Binding var activeRecordKey: String
    @Binding var activeTime: Time
    
    // Action callbacks
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onSave: (ECheckInAllResponse) -> Void
    let onDelete: (ECheckInAllResponse) -> Void
    let onFeedback: (ECheckInAllResponse, Int) -> Void
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if config.showCheckbox {
                RecordHeaderView(
                    record: record,
                    checkboxManager: checkboxManager
                )
            } else {
                BasicRecordHeader(record: record)
            }
            
            RecordDetailsViewFixed(
                record: record,
                userRating: $userRating,
                showStarRating: config.showStarRating,
                onFeedback: { rating in
                    onFeedback(record, rating)
                }
            )
            
            if config.showTimePickers && config.isEditable {
                TimePickersView(
                    record: record,
                    selectedStartTimes: selectedStartTimes,
                    selectedEndTimes: selectedEndTimes,
                    onTimePickerTap: onTimePickerTap
                )
            }
            
            if config.showReasonDropdown && config.isEditable {
                ReasonDropdownView(
                    record: record,
                    showReasonDropdown: $showReasonDropdown,
                    selectedReasons: $selectedReasons,
                    reasonComments: $reasonComments,
                    onReasonSave: onReasonSave
                )
            }
            
            if config.showActions && config.isEditable {
                RecordActionsView(
                    record: record,
                    onSave: { onSave(record) },
                    onDelete: { onDelete(record) }
                )
            }
        }
        .padding(16)
        .background(Color(.systemGray4).opacity(0.3))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// 6. Record Header with Checkbox
struct RecordHeaderView: View {
    let record: ECheckInAllResponse
    @ObservedObject var checkboxManager: CheckboxManager
    
    var body: some View {
        HStack {
            Text(record.candidateName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            StatusIndicator(isSubmitted: record.isSubmitted == 1)
            
            Spacer()
            
            CheckboxView(
                item: record,
                isSelected: checkboxManager.isSelected(record.id), // ✅ use manager state
                onToggle: {
                    checkboxManager.toggleRecord(record) // ✅ update manager
                }
            )
        }
    }
}

//struct RecordHeaderView: View {
//    let record: ECheckInAllResponse
//    let checkboxManager: CheckboxManager
//    
//    var body: some View {
//        HStack {
//            Text(record.candidateName)
//                .font(.system(size: 16, weight: .semibold))
//                .foregroundColor(.primary)
//            
//            StatusIndicator(isSubmitted: record.isSubmitted == 1)
//            
//            Spacer()
//            
//            CheckboxView(
//                item: record,
//                isSelected: true,
//                onToggle: {
//                    print("Toggled")
//                }
//            )
//            
////            CheckboxButton(
////                isSelected: checkboxManager.isSelected(record.id),
////                action: {
////                    withAnimation(.easeInOut(duration: 0.2)) {
////                        checkboxManager.toggleRecord(record)
////                    }
////                }
////            )
//        }
//    }
//}

struct CheckboxView: View {
    let item: ECheckInAllResponse
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: checkboxIcon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(checkboxColor)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .disabled(!item.canBeSelected)
        .opacity(item.canBeSelected ? 1.0 : 0.6)
    }
    
    private var checkboxIcon: String {
        if !item.canBeSelected {
            return "lock.fill"
        }
        return isSelected ? "checkmark.square.fill" : "square"
    }
    
    private var checkboxColor: Color {
        if !item.canBeSelected {
            return .gray
        }
        return isSelected ? .blue : .gray
    }
}


// 7. Basic Record Header (without checkbox)
struct BasicRecordHeader: View {
    let record: ECheckInAllResponse
    
    var body: some View {
        HStack {
            Text(record.candidateName ?? "Unknown")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            StatusIndicator(isSubmitted: record.isSubmitted == 1)
            
            Spacer()
        }
    }
}

// 8. Status Indicator Component
struct StatusIndicator: View {
    let isSubmitted: Bool
    
    var body: some View {
        Circle()
            .fill(isSubmitted ? Color.green : Color.orange)
            .frame(width: 8, height: 8)
    }
}

// 9. Checkbox Button Component
struct CheckboxButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .blue : Color(.systemGray3))
        }
    }
}

// 10. Record Details Component
struct RecordDetailsView: View {
    let record: ECheckInAllResponse
    @Binding var userRating: Int
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showStarRating {
                StarRatingSection(
                    rating: $userRating,
                    onFeedback: onFeedback
                )
            }
            
            PositionView(record: record)
            ScheduleTimeView(record: record)
            TotalHoursView(record: record)
            BreakMinutesView(record: record)
        }
    }
}

// 11. Star Rating Section
struct StarRatingSection: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                if newRating <= 2 {
                    onFeedback(newRating)
                }
            }
            
            Button {
                // onFeedback(rating)
                
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// 12. Position View Component
struct PositionView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
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
}

// 13. Schedule Time View Component
struct ScheduleTimeView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
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
}

// 14. Total Hours View Component
struct TotalHoursView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
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
}

// 15. Break Minutes View Component
struct BreakMinutesView: View {
    let record: ECheckInAllResponse
    
    var body: some View {
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
}

// 16. Time Pickers View Component
struct TimePickersView: View {
    let record: ECheckInAllResponse
    let selectedStartTimes: [String: Time]
    let selectedEndTimes: [String: Time]
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TimePickerButton(
                record: record,
                timeType: .start,
                placeholder: record.checkIn.toTimeAMPM() ?? "1:22 AM",
                selectedTime: selectedStartTimes[record.checkIn],
                onTap: { onTimePickerTap(record, .start) }
            )
            
            TimePickerButton(
                record: record,
                timeType: .end,
                placeholder: record.checkOut.toTimeAMPM() ?? "1:27 AM",
                selectedTime: selectedEndTimes[record.checkOut],
                onTap: { onTimePickerTap(record, .end) }
            )
        }
    }
}

// 17. Time Picker Button Component
struct TimePickerButton: View {
    let record: ECheckInAllResponse
    let timeType: TimeType
    let placeholder: String
    let selectedTime: Time?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(timeText)
                    .foregroundColor(selectedTime == nil ? Color(.black) : Color(.label))
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "clock.fill")
                    .foregroundColor(Color(.theme))
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "#778da9"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemBlue), lineWidth: 1)
            )
        }
    }
    
    private var timeText: String {
        if let selectedTime = selectedTime {
            return Date_Time_Formatter.formatTime(selectedTime)
        }
        return placeholder
    }
}

// 18. Reason Dropdown Component
struct ReasonDropdownView: View {
    let record: ECheckInAllResponse
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                DropdownButton(
                    record: record,
                    showDropdown: showReasonDropdown[record.id] == true,
                    selectedReason: selectedReasons[record.id],
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showReasonDropdown[record.id] = !(showReasonDropdown[record.id] ?? false)
                        }
                    }
                )
                
                SaveReasonButton(
                    record: record,
                    onSave: {
                        if let selectedReason = selectedReasons[record.id] {
                            onReasonSave(record, selectedReason, reasonComments[record.id] ?? "")
                        }
                    }
                )
            }
            
            if showReasonDropdown[record.id] == true && record.isSubmitted == 0 {
                ReasonOptionsView(
                    record: record,
                    selectedReasons: $selectedReasons,
                    showReasonDropdown: $showReasonDropdown
                )
            }
        }
    }
}

// 19. Dropdown Button Component
struct DropdownButton: View {
    let record: ECheckInAllResponse
    let showDropdown: Bool
    let selectedReason: ReasonType?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Text(selectedReason?.displayName ?? "Reason For Irregular Hours")
                    .foregroundColor(selectedReason != nil ? Color(.label) : Color(.systemGray))
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
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
        .disabled(record.isSubmitted == 1)
        .opacity(record.isSubmitted == 1 ? 0.5 : 1)
    }
}

// 20. Save Reason Button Component
struct SaveReasonButton: View {
    let record: ECheckInAllResponse
    let onSave: () -> Void
    
    var body: some View {
        Button(action: {
            if record.isSubmitted == 0 {
                onSave()
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
        .disabled(record.isSubmitted == 1)
    }
}

// 21. Reason Options View Component
struct ReasonOptionsView: View {
    let record: ECheckInAllResponse
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var showReasonDropdown: [Int: Bool]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(ReasonType.allCases, id: \.self) { reason in
                Button(action: {
                    selectedReasons[record.id] = reason
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showReasonDropdown[record.id] = false
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
                    Divider().padding(.leading, 12)
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

// 22. Record Actions View Component
struct RecordActionsView: View {
    let record: ECheckInAllResponse
    let onSave: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            DeleteButton(
                isEnabled: record.isSubmitted == 0,
                onDelete: onDelete
            )
            
            Spacer()
            
            SaveButton(
                isEnabled: record.isSubmitted == 0,
                onSave: onSave
            )
        }
        .padding(.top, 8)
    }
}

// 23. Delete Button Component
struct DeleteButton: View {
    let isEnabled: Bool
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onDelete) {
            Image(systemName: "trash.fill")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .frame(width: 32, height: 32)
                .background(Color.red.opacity(0.1))
                .cornerRadius(6)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// 24. Save Button Component
struct SaveButton: View {
    let isEnabled: Bool
    let onSave: () -> Void
    
    var body: some View {
        Button(action: onSave) {
            Text("Save")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(isEnabled ? Color(hex: "#111184") : Color(.systemGray4))
                .cornerRadius(8)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Refactored Main View
//struct OverAllUI: View {
//    // Configuration
//    private let config: ECheckinConfig
//    private let recordConfig: RecordCardConfig
//    @StateObject private var checkboxManager = CheckboxManager()
//    @State private var showDeleteAlert = false
//    @State private var activeRecordForDeletion: ECheckInAllResponse? = nil
//    @State private var deleteCandidateName: String = ""
//    // State variables (keeping all existing ones)
//    @State private var showTimePicker = false
//    @State private var selectedDate: Date = Date()
//    @State private var userRating = 0
//    @State private var showFeedbackAlert = false
//    @State private var feedbackText = ""
//    @State private var startDate: Date? = Date()
//    @State private var tappedDate: Date? = Date()
//    @State private var startTime: Time? = Time()
//    @State private var isChecked: Bool = false
//    @State private var showDatePicker = false
//    @State private var showAlert = false
//    @State private var activeItemID: UUID? = nil
//    @State private var activeTime: Time = Time()
//    @State private var selectedTimes: [UUID: Time] = [:]
//    @State private var activeTimeType: TimeType = .start
//    @State private var activeRecordKey: String = ""
////    @State private var showSaveAlert = false
////    @State private var showFeedBackAlert = false
//    @State private var activeAlert: ActiveModeAlert?
//    @State private var showLogoutAlert = false
//    @State private var savedRemark: String = ""
//    @State private var selectedStartTimes: [String: Time] = [:]
//    @State private var selectedEndTimes: [String: Time] = [:]
//
//    var totalSelected: [ECheckInAllResponse] = []
//    var notValidArrayList: [[String:Any]] = []
//    @State private var showSaveAlertWithNote = false
//    @State private var noteText: String = ""
//    @State private var showReasonDropdown: [Int: Bool] = [:]
//    @State private var selectedReasons: [Int: ReasonType] = [:]
//    @State private var reasonComments: [Int: String] = [:]
//    @State private var showReasonAlert = false
//    @State private var activeReasonRecordID = 0
//    @State private var tempReasonComment = ""
//    @State private var alertTitle = ""
//    @State private var alertTitleColor: Color = .black
//    @State private var alertTitleBg: Color = .white
//    @State private var buttonBg: Color = .blue
//    @State private var buttonTitleColor: Color = .white
//    @State private var textFieldAlert: TextFieldAlert? = nil
//    @State private var activeRecordForSave: ECheckInAllResponse? = nil
//    @State private var startSelectedTime: String? = ""
//    @State private var endSelectedTime: String? = ""
//    @State var viewModel = OverallVM()
//    @EnvironmentObject var errorHandler: GlobalErrorHandler
//    @State private var items: [AllItem] = []
//
//    // Computed properties
//    var isSubmitEnabled: Bool {
//        checkboxManager.submissionArray.count > 1
//    }
//
//    var canSave: Bool {
//        guard let res = viewModel.echeckallData.first else { return false }
//        return res.isSubmitted == 0
//    }
//
//    var canDelete: Bool {
//        guard let res = viewModel.echeckallData.first else { return false }
//        return res.isSubmitted == 0
//    }
//
//    // Initializer with configuration
//    init(clientID: Int?, contactID: Int?, config: ECheckinConfig? = nil, recordConfig: RecordCardConfig? = nil) {
//        self.config = config ?? ECheckinConfig(clientID: clientID, contactID: contactID)
//        self.recordConfig = recordConfig ?? RecordCardConfig(showStarRating: true, showCheckbox: true, showReasonDropdown: true)
//    }
//
//    var body: some View {
//        ZStack {
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                // Header
//                ECheckinHeaderView(
//                    selectedDate: $startDate,
//                    showDatePicker: $showDatePicker,
//                    onGoButtonTap: handleGoButtonTap,
//                    onSubmitTap: handleSubmitTap,
//                    onInfoTap: handleInfoTap,
//                    isSubmitEnabled: !checkboxManager.selectedRecords.isEmpty // Fixed
//                )
//
//                // Records list
//                recordsScrollView
//            }
//            alertHandling
//            overlayViews
//
//            if viewModel.isLoading {
//                       Color.black.opacity(0.5)
//                           .ignoresSafeArea()
//
//                       TriangleLoader()
//                   }
//        }
//        .onAppear(perform: handleViewAppear)
//        // CRITICAL: Add the delete alert modifier here, not in overlay
//        .alert("Delete Record", isPresented: $showDeleteAlert) {
//            Button("Delete", role: .destructive) {
//                guard let record = activeRecordForDeletion else { return }
//                performDelete(record)
//            }
//            Button("Cancel", role: .cancel) {
//                activeRecordForDeletion = nil
//            }
//        } message: {
//            Text("Are you sure you want to delete this record for \(deleteCandidateName)?")
//        }
//        // Other existing modifiers...
//    }
//
//
//    // MARK: - Records ScrollView using reusable components
//    private var recordsScrollView: some View {
//        ScrollView {
//            LazyVStack(spacing: 12) {
//                ForEach(viewModel.echeckallData.indices, id: \.self) { index in
//                    RecordCardView(
//                        record: viewModel.echeckallData[index],
//                        index: index,
//                        config: recordConfig,
//                        checkboxManager: checkboxManager,
//                        selectedStartTimes: $selectedStartTimes,
//                        selectedEndTimes: $selectedEndTimes,
//                        showReasonDropdown: $showReasonDropdown,
//                        selectedReasons: $selectedReasons,
//                        reasonComments: $reasonComments,
//                        userRating: $userRating,
//                        showTimePicker: $showTimePicker,
//                        activeTimeType: $activeTimeType,
//                        activeRecordKey: $activeRecordKey,
//                        activeTime: $activeTime,
//                        onTimePickerTap: handleTimePickerTap,
//                        onSave: handleSaveRecord,
//                        onDelete: handleDeleteRecord,
//                        onFeedback: handleFeedback,
//                        onReasonSave: handleReasonSave
//                    )
//                }
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 8)
//        }
//    }
//
//    // MARK: - Action Handlers
//    private func handleGoButtonTap() {
//        guard let clientID = config.clientID,
//              let contactID = config.contactID else {
//            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
//            return
//        }
//
//        if let startDate = tappedDate {
//            viewModel.echeckallData.removeAll()
//            viewModel.fetchOverallDetails(
//                contactId: "\(contactID)",
//                clientId: "\(clientID)",
//                weekEnd: Date_Time_Formatter.APIformatDate(startDate),
//                errorHandler: errorHandler
//            )
//        }
//    }
//
//    private func handleSubmitTap() {
//        viewModel.overallSubmit(params: checkboxManager.submissionArray, errorHandler: errorHandler)
//    }
//
//    private func handleInfoTap() {
//        withAnimation {
//            showAlert.toggle()
//        }
//    }
//
//    private func handleTimePickerTap(_ record: ECheckInAllResponse, _ timeType: TimeType) {
//        switch timeType {
//        case .start:
//            activeRecordKey = record.checkIn
//        case .end:
//            activeRecordKey = record.checkOut
//        }
//        activeTimeType = timeType
//        showTimePicker = true
//    }
//
//
//
//
//    // MARK: - Fixed Save Handler
//    private func handleSaveRecord(_ record: ECheckInAllResponse) {
//        print("Save button tapped for record: \(record.candidateName)")
//
//        activeRecordForSave = record
//
//        // Create and set the TextFieldAlert
//        textFieldAlert = TextFieldAlert(
//            title: "Save Record",
//            message: "Enter reason for changing time:",
//            placeholder: "Enter note..."
//        ) { note in
//            print("Save alert completed with note: \(note ?? "nil")")
//
//            let noteText = note ?? ""
//
//            viewModel.saveRecordDetails(
//                response: record,
//                contactId: String(config.contactID ?? 0),
//                clientId: String(config.clientID ?? 0),
//                checkin: record.checkIn,
//                checkout: record.checkOut,
//                note: noteText,
//                errorHandler: errorHandler
//            )
//
//            // Refresh data after save
//            viewModel.fetchOverallDetails(
//                contactId: String(config.contactID ?? 0),
//                clientId: String(config.clientID ?? 0),
//                weekEnd: Date_Time_Formatter.APIformatDate(startDate ?? Date()),
//                errorHandler: errorHandler
//            )
//
//            activeRecordForSave = nil
//        }
//
//        print("TextFieldAlert created and assigned")
//    }
//
//
//
//
//
//    // MARK: - Fixed Rating Alert Handler
//    private func handleFeedback(_ rating: Int) {
//        userRating = rating // Make sure to set the rating
//
//        if rating <= 2 {
//            // Use TextFieldAlert for feedback input
//            textFieldAlert = TextFieldAlert(
//                title: "Feedback Required",
//                message: "Your rating is \(rating)/5. Please provide feedback:",
//                placeholder: "Enter your feedback..."
//            ) { feedback in
//                let feedbackText = feedback ?? ""
//                savedRemark = feedbackText
//
//                // Submit feedback using viewModel
//                if let firstRecord = viewModel.echeckallData.first {
//                    viewModel.fetchFeedbackDeatils(
//                        clientId: "\(config.clientID ?? 0)",
//                        weekEnd: firstRecord.weekEnd,
//                        rating: String(rating),
//                        source: String(rating),
//                        CandId: "\(firstRecord.candID)",
//                        OrderId: "\(firstRecord.orderID)",
//                        comments: feedbackText,
//                        ClientContacts: String(config.contactID ?? 0),
//                        errorHandler: errorHandler
//                    )
//                }
//            }
//        } else {
//            // For ratings above 2, you might want to show a success message
//            // or handle differently based on your requirements
//            if let firstRecord = viewModel.echeckallData.first {
//                viewModel.fetchFeedbackDeatils(
//                    clientId: "\(config.clientID ?? 0)",
//                    weekEnd: firstRecord.weekEnd,
//                    rating: String(rating),
//                    source: String(rating),
//                    CandId: "\(firstRecord.candID)",
//                    OrderId: "\(firstRecord.orderID)",
//                    comments: "Good rating: \(rating)/5",
//                    ClientContacts: String(config.contactID ?? 0),
//                    errorHandler: errorHandler
//                )
//            }
//        }
//    }
//
//    // MARK: - Fixed Alert Handling View
//    // MARK: - Updated Alert Handling (Removed duplicate TextFieldWrapper)
//    private var alertHandling: some View {
//        Group {
//            // Handle ViewModel alerts
//            if viewModel.showAlert, let message = viewModel.alertMessage {
//                if viewModel.alertType == .success {
//                    AlertView(
//                        title: "EMA 2.0",
//                        message: message,
//                        primaryButton: AlertButtonConfig(title: "OK") {
//                            viewModel.showAlert = false
//                        },
//                        dismiss: { viewModel.showAlert = false },
//                        alertType: .success
//                    )
//                } else {
//                    AlertView(
//                        title: "EMA 2.0",
//                        message: message,
//                        primaryButton: AlertButtonConfig(title: "Retry") {
//                            // Retry logic
//                            viewModel.showAlert = false
//                        },
//                        secondaryButton: AlertButtonConfig(title: "Cancel") {
//                            viewModel.showAlert = false
//                        },
//                        dismiss: { viewModel.showAlert = false },
//                        alertType: .error
//                    )
//                }
//            }
//        }
//    }
//
//
//    // MARK: - Simplified Overlay Views (Remove redundant save alert overlay)
//    private var overlayViews: some View {
//        ZStack {
//            if showDatePicker {
//                datePickerOverlay
//            }
//
//            if showTimePicker {
//                timePickerOverlay
//            }
//
//            if showAlert {
//                CustomAlertView(show: $showAlert)
//            }
//
//            // Add the delete alert overlay (but it should be handled by modifier)
//            deleteAlertOverlay
//        }
//    }
//
//    private func handleDeleteRecord(_ record: ECheckInAllResponse) {
//        activeRecordForDeletion = record
//        deleteCandidateName = record.candidateName ?? "this candidate"
//        showDeleteAlert = true // This should trigger the alert
//    }
//
//    private func performDelete(_ record: ECheckInAllResponse) {
//        viewModel.deleteRecords(
//            responseData: record,
//            contactId: String(config.contactID ?? 0),
//            clientId: String(config.clientID ?? 0),
//            errorHandler: errorHandler
//        )
//
//        // Remove from checkbox manager if selected
//        checkboxManager.removeRecord(record.id)
//
//        // Clear active record
//        activeRecordForDeletion = nil
//
//        // Refresh data
//        refreshData()
//    }
//
//    private func refreshData() {
//        guard let clientID = config.clientID,
//              let contactID = config.contactID else { return }
//
//        viewModel.fetchOverallDetails(
//            contactId: String(contactID),
//            clientId: String(clientID),
//            weekEnd: Date_Time_Formatter.APIformatDate(startDate ?? Date()),
//            errorHandler: errorHandler
//        )
//    }
//
//    private func handleReasonSave(_ record: ECheckInAllResponse, _ reason: ReasonType, _ comment: String) {
//        viewModel.selectReasonDetails(
//            responseData: record,
//            reasonID: record.id,
//            reasonType: reason.rawValue,
//            reasonComment: comment,
//            ClientId: config.clientID ?? 0,
//            ContactId: config.contactID ?? 0,
//            errorHandler: errorHandler
//        )
//    }
//
//    private func handleViewAppear() {
//        guard let clientID = config.clientID,
//              let contactID = config.contactID else {
//            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
//            return
//        }
//
//        viewModel.fetchOverallDetails(
//            contactId: "\(contactID)",
//            clientId: "\(clientID)",
//            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
//            errorHandler: errorHandler
//        )
//    }
//
//    // MARK: - Overlay Views (keeping existing functionality)
////    private var overlayViews: some View {
////        ZStack {
////            if showDatePicker {
////                datePickerOverlay
////            }
////
////            if showDeleteAlert {
////                deleteAlertOverlay
////            }
////
////            if showSaveAlert {
////                saveAlertOverlay
////            }
////
////            if showTimePicker {
////                timePickerOverlay
////            }
////
////            if showAlert {
////                CustomAlertView(show: $showAlert)
////            }
////        }
////    }
//
//    // MARK: - Existing overlays (keeping all functionality)
//    private var datePickerOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture { showDatePicker = false }
//
//            VStack {
//                Custom_Calander_View(
//                    showDatePicker: $showDatePicker,
//                    selectedDate: $selectedDate,
//                    onDateSelection: { date in
//                        selectedDate = date
//                        startDate = date
//                        tappedDate = date
//                        showDatePicker = false
//                    }
//                )
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .clipped()
//            }
//        }
//        .zIndex(10)
//    }
//
//
//
//    private var saveAlertOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture { showAlert = false }
//
//        }
//        .zIndex(10)
//    }
//
//    private var timePickerOverlay: some View {
//        ZStack {
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture { showTimePicker = false }
//
//            Custom_Timer(
//                showTimePicker: $showTimePicker,
//                selectedTime: $activeTime
//            ) { time in
//                switch activeTimeType {
//                case .start:
//                    selectedStartTimes[activeRecordKey] = time
//                    startSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
//                case .end:
//                    selectedEndTimes[activeRecordKey] = time
//                    endSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .zIndex(10)
//    }
//
//    // MARK: - Alert Handling (keeping existing functionality)
////    private var alertHandling: some View {
////        Group {
////            if viewModel.showAlert, let message = viewModel.alertMessage {
////                if viewModel.alertType == .success {
////                    AlertView(
////                        title: "EMA 2.0",
////                        message: message,
////                        primaryButton: AlertButtonConfig(title: "OK") {
////                            viewModel.showAlert = false
////                        },
////                        dismiss: { viewModel.showAlert = false },
////                        alertType: .success
////                    )
////                } else {
////                    AlertView(
////                        title: "EMA 2.0",
////                        message: message,
////                        primaryButton: AlertButtonConfig(title: "Retry") {
////                            if let firstItem = viewModel.echeckallData.first,
////                               let clientID = config.clientID,
////                               let contactID = config.contactID {
////                                // Retry logic
////                            }
////                            viewModel.showAlert = false
////                        },
////                        secondaryButton: AlertButtonConfig(title: "Cancel") {
////                            viewModel.showAlert = false
////                        },
////                        dismiss: { viewModel.showAlert = false },
////                        alertType: .error
////                    )
////                }
////
////            }
////        }
////        .alert("Enter Remark", isPresented: $showFeedbackAlert, presenting: activeAlert) { alertType in
////            if alertType == .feedback {
////                TextField("Enter your remark", text: $feedbackText)
////                Button("Submit") {
////                    savedRemark = feedbackText
////                    // Handle feedback submission using viewModel
////                    if let firstRecord = viewModel.echeckallData.first {
////                        viewModel.fetchFeedbackDeatils(
////                            clientId: "\(config.clientID ?? 0)",
////                            weekEnd: firstRecord.weekEnd,
////                            rating: String(userRating),
////                            source: String(userRating),
////                            CandId: "\(firstRecord.candID)",
////                            OrderId: "\(firstRecord.orderID)",
////                            comments: feedbackText,
////                            ClientContacts: String(config.contactID ?? 0),
////                            errorHandler: errorHandler
////                        )
////                    }
////                    feedbackText = ""
////                }
////                Button("Cancel", role: .cancel) { }
////            } else if alertType == .info {
////                Button("OK", role: .cancel) { }
////            }
////        } message: { alertType in
////            if alertType == .info {
////                Text(savedRemark.isEmpty ? "No feedback yet" : savedRemark)
////            }
////        }
////        .alert("Add Comment", isPresented: $showReasonAlert) {
////            TextField("Enter comment for irregular hours", text: $tempReasonComment)
////            Button("Save Reason") {
////                reasonComments[activeReasonRecordID] = tempReasonComment
////
////                if let record = viewModel.echeckallData.first(where: { $0.id == activeReasonRecordID }),
////                   let selectedReason = selectedReasons[activeReasonRecordID] {
////                    viewModel.selectReasonDetails(
////                        responseData: record,
////                        reasonID: record.id,
////                        reasonType: selectedReason.rawValue,
////                        reasonComment: tempReasonComment,
////                        ClientId: config.clientID ?? 0,
////                        ContactId: config.contactID ?? 0,
////                        errorHandler: errorHandler
////                    )
////                }
////                tempReasonComment = ""
////            }
////            Button("Cancel", role: .cancel) {
////                tempReasonComment = ""
////            }
////        } message: {
////            Text("Please provide additional details for the selected reason.")
////        }
////        .background(TextFieldWrapper(alert: $textFieldAlert).frame(width: 300, height: 300))
////    }
//}

// MARK: - Preview with Configuration
//struct ECheckin_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Default configuration
//            OverAllUI(clientID: 1, contactID: 1)
//                .environmentObject(GlobalErrorHandler())
//                .previewDisplayName("Default")
//
//            // Read-only configuration
//            OverAllUI(
//                clientID: 1,
//                contactID: 1,
//                recordConfig: RecordCardConfig(
//                    showCheckbox: false,
//                    isEditable: false
//                )
//            )
//            .environmentObject(GlobalErrorHandler())
//            .previewDisplayName("Read Only")
//
//            // Minimal configuration
//            OverAllUI(
//                clientID: 1,
//                contactID: 1,
//                recordConfig: RecordCardConfig(
//                    showStarRating: false,
//                    showReasonDropdown: false,
//                    showActions: false
//                )
//            )
//            .environmentObject(GlobalErrorHandler())
//            .previewDisplayName("Minimal")
//        }
//    }
//}

// MARK: - Usage Examples and Factory Methods

//extension OverAllUI {
//    // Factory method for read-only view
//    static func readOnly(clientID: Int?, contactID: Int?) -> OverAllUI {
//        return OverAllUI(
//            clientID: clientID,
//            contactID: contactID,
//            config: ECheckinConfig(
//               clientID: clientID,
//                contactID: contactID,
//                canSubmit: false,
//                canDelete: false,
//                canSave: false
//            ),
//            recordConfig: RecordCardConfig(
//                showStarRating: true, showCheckbox: true,
//                showReasonDropdown: true, showActions: true,
//                isEditable: true
//            )
//        )
//    }
//
//    // Factory method for minimal view
//    static func minimal(clientID: Int?, contactID: Int?) -> OverAllUI {
//        return OverAllUI(
//            clientID: clientID,
//            contactID: contactID,
//            recordConfig: RecordCardConfig(
//                showStarRating: true,
//                showCheckbox: true,
//                showReasonDropdown: true,
//                showTimePickers: true,
//                showActions: true, isEditable: true
//            )
//        )
//    }
//
//    // Factory method for submission-only view
//    static func submissionOnly(clientID: Int?, contactID: Int?) -> OverAllUI {
//        return OverAllUI(
//            clientID: clientID,
//            contactID: contactID,
//            recordConfig: RecordCardConfig(
//                showStarRating: true,
//                showCheckbox: true,
//                showReasonDropdown: true
//            )
//        )
//    }
//}
//
//// MARK: - Reusable CheckboxManager (Enhanced)
//extension CheckboxManager {
//    // Configuration method for different use cases
//    func configure(clientID: Int, contactID: Int, startTime: String?, endTime: String?) {
//        self.clientid = clientID
//        self.contactid = contactID
//        self.startSelectedTime = startTime
//        self.endSelectedTime = endTime
//    }
//
//    // Batch operations
//    func selectAll(_ records: [ECheckInAllResponse]) {
//        for record in records where record.isSubmitted == 0 {
//            if !selectedRecords.contains(record.id) {
//                addRecord(record, extraFields: extraFields)
//            }
//        }
//    }
//
//    func deselectAll() {
//        clearAll()
//    }
//
//    // Filter methods
//    func getSelectedRecords(from records: [ECheckInAllResponse]) -> [ECheckInAllResponse] {
//        return records.filter { selectedRecords.contains($0.id) }
//    }
//
//    func getUnselectedRecords(from records: [ECheckInAllResponse]) -> [ECheckInAllResponse] {
//        return records.filter { !selectedRecords.contains($0.id) }
//    }
//}
//
//// MARK: - Protocol for Custom Record Types
//protocol CheckinRecordProtocol {
//    var id: Int { get }
//    var candidateName: String? { get }
//    var isSubmitted: Int { get }
//    var checkIn: String { get }
//    var checkOut: String { get }
//    var position: String { get }
//    var totalHours: String? { get }
//}
//
//extension CheckinRecordProtocol {
//    var candidateName: String? { nil }
//    var totalHours: String? { nil }
//}
//
//
//// MARK: - Generic Record Card for different record types
//struct GenericRecordCardView<T: CheckinRecordProtocol>: View {
//    let record: T
//    let config: RecordCardConfig
//    let onAction: (T, String) -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Text((record.candidateName ?? "Unknown") ?? "")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.primary)
//
//                StatusIndicator(isSubmitted: record.isSubmitted == 1)
//
//                Spacer()
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Text("Position:")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color(.systemGray))
//
//                    Text(record.position)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.primary)
//
//                    Spacer()
//                }
//
//                HStack {
//                    Text("Total Hours:")
//                        .font(.system(size: 14))
//                        .foregroundColor(Color(.systemGray))
//
//                    Text(record.totalHours ?? "")
//                        .font(.system(size: 14))
//                        .foregroundColor(.primary)
//
//                    Spacer()
//                }
//            }
//
//            if config.showActions && config.isEditable {
//                HStack {
//                    Button("Action 1") {
//                        onAction(record, "action1")
//                    }
//                    .disabled(record.isSubmitted == 1)
//
//                    Spacer()
//
//                    Button("Action 2") {
//                        onAction(record, "action2")
//                    }
//                    .disabled(record.isSubmitted == 1)
//                }
//            }
//        }
//        .padding(16)
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
//    }
//}
//
//extension OverAllUI {
//    private var deleteAlertOverlay: some View {
//        // Remove the ZStack overlay approach and use SwiftUI's built-in alert
//        EmptyView()
//            .alert("Delete Record", isPresented: $showDeleteAlert) {
//                Button("Delete", role: .destructive) {
//                    guard let record = activeRecordForDeletion else { return }
//
//                    viewModel.deleteRecords(
//                        responseData: record,
//                        contactId: String(config.contactID ?? 0),
//                        clientId: String(config.clientID ?? 0),
//                        errorHandler: errorHandler
//                    )
//
//                    // Clear the active record after deletion
//                    activeRecordForDeletion = nil
//
//                    // Refresh data after deletion
//                    if let clientID = config.clientID,
//                       let contactID = config.contactID {
//                        viewModel.fetchOverallDetails(
//                            contactId: String(contactID),
//                            clientId: String(clientID),
//                            weekEnd: Date_Time_Formatter.APIformatDate(startDate ?? Date()),
//                            errorHandler: errorHandler
//                        )
//                    }
//                }
//
//                Button("Cancel", role: .cancel) {
//                    activeRecordForDeletion = nil
//                }
//            } message: {
//                Text("Are you sure you want to delete this record for \(deleteCandidateName)?")
//            }
//    }
//}
//
//// MARK: - Issue 3: Fixed Overlay Views
//// Your overlayViews computed property has inconsistent implementation
//
//
//
//// MARK: - Issue 4: Fixed Submit Button Logic
//// The submit button enabled state has issues
//// MARK: - Issue 6: CheckboxButton Animation Fix
//struct CheckboxButtonFixed: View {
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: {
//            // Add haptic feedback for better UX
//            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
//            impactFeedback.impactOccurred()
//            action()
//        }) {
//            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
//                .font(.system(size: 20))
//                .foregroundColor(isSelected ? .blue : Color(.systemGray3))
//                .animation(.easeInOut(duration: 0.2), value: isSelected) // Add animation
//        }
//        .buttonStyle(PlainButtonStyle()) // Prevent button highlighting issues
//    }
//}
//
//// MARK: - Debugging Helpers
//// Add these to help debug the issues:
//
//extension CheckboxManager {
//    func debugStatus() {
//        print("Selected Records: \(selectedRecords)")
//        print("Submission Array Count: \(submissionArray.count)")
//        print("Submission Array: \(submissionArray)")
//    }
//}
//
//// MARK: - Usage in RecordCardView
//// Make sure your RecordCardView is using the checkbox correctly:
//extension RecordCardView {
//    private func debugCheckboxTap(_ record: ECheckInAllResponse) {
//        print("Checkbox tapped for record: \(record.id)")
//        print("Current selection state: \(checkboxManager.isSelected(record.id))")
//
//        checkboxManager.toggleRecord(record)
//        checkboxManager.debugStatus()
//    }
//}

// MARK: - Fixed OverAllUI Implementation
struct OverAllUI: View {
    // Configuration
    private let config: ECheckinConfig
    private let recordConfig: RecordCardConfig
    @StateObject private var checkboxManager = CheckboxManager()
    // Alert States - Properly organized
    @State private var showDeleteAlert = false
    @State private var activeRecordForDeletion: ECheckInAllResponse? = nil
    @State private var deleteCandidateName: String = ""
    @State private var textFieldAlert: TextFieldAlert? = nil
    @State private var activeRecordForSave: ECheckInAllResponse? = nil
    @State private var recordRatings: [String: Int] = [:] // recordID -> rating

    // Time and Date States
    @State private var showTimePicker = false
    @State private var selectedDate: Date = Date()
    @State private var startDate: Date? = Date()
    @State private var tappedDate: Date? = Date()
    @State private var showDatePicker = false
    @State private var activeTime: Time = Time()
    @State private var activeTimeType: TimeType = .start
    @State private var activeRecordKey: String = ""
    @State private var selectedStartTimes: [String: Time] = [:]
    @State private var selectedEndTimes: [String: Time] = [:]
    
    // Rating and Feedback States
    @State private var userRating = 0
    @State private var feedbackText = ""
    @State private var savedRemark: String = ""
    
    // Reason States
    @State private var showReasonDropdown: [Int: Bool] = [:]
    @State private var selectedReasons: [Int: ReasonType] = [:]
    @State private var reasonComments: [Int: String] = [:]
    
    // UI States
    @State private var showAlert = false
    @State private var startSelectedTime: String? = ""
    @State private var endSelectedTime: String? = ""
    
    @State var viewModel = OverallVM()
    @EnvironmentObject var errorHandler: GlobalErrorHandler
    
    // Computed properties
    var isSubmitEnabled: Bool {
        !checkboxManager.selectedRecords.isEmpty
    }
    
    // Initializer
    init(clientID: Int?, contactID: Int?, config: ECheckinConfig? = nil, recordConfig: RecordCardConfig? = nil) {
        self.config = config ?? ECheckinConfig(clientID: clientID, contactID: contactID)
        self.recordConfig = recordConfig ?? RecordCardConfig()
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                
            VStack(spacing: 0) {
                // Header
                ECheckinHeaderView(
                    selectedDate: $startDate,
                    showDatePicker: $showDatePicker,
                    onGoButtonTap: handleGoButtonTap,
                    onSubmitTap: handleSubmitTap,
                    onInfoTap: handleInfoTap,
                    isSubmitEnabled: isSubmitEnabled
                )
                
                // Records list
                recordsScrollView
                .frame(maxWidth: .infinity)
                .padding(.bottom, 90) // extra safe space for last element
            }
            
            // Overlays
            overlayViews
            
            // Loading indicator
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
                            //                           if let firstItem = viewModel.echeckallData.first,
                            //                              let clientID = clientID,
                            //                              let contactID = contactID {
                            //                           }
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
        .onAppear(perform: handleViewAppear)
        // Alert modifiers
        .alert("Delete Record", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let record = activeRecordForDeletion {
                    performDelete(record)
                }
            }
            Button("Cancel", role: .cancel) {
                activeRecordForDeletion = nil
            }
        } message: {
            Text("Are you sure you want to delete this record for \(deleteCandidateName)?")
        }
        .background(
            // TextFieldAlert handling
            TextFieldWrapper(alert: $textFieldAlert)
                .frame(width: 0, height: 0)
                .opacity(0)
        )
        // ViewModel alerts
        .onChange(of: viewModel.showAlert) { showAlert in
            if showAlert {
                handleViewModelAlert()
            }
        }
    }
    
    // MARK: - Records ScrollView
    private var recordsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.echeckallData.indices, id: \.self) { index in
                    let record = viewModel.echeckallData[index]
                    RecordCardViewFixed(
                        record: record,
                        index: index,
                        config: recordConfig,
                        checkboxManager: checkboxManager,
                        selectedStartTimes: $selectedStartTimes,
                        selectedEndTimes: $selectedEndTimes,
                        showReasonDropdown: $showReasonDropdown,
                        selectedReasons: $selectedReasons,
                        reasonComments: $reasonComments,
                        userRating: Binding(
                            get: { recordRatings["\(record.id)"] ?? (record.rating) },
                            set: { recordRatings["\(record.id)"] = $0 }
                        ),
                        showTimePicker: $showTimePicker,
                        activeTimeType: $activeTimeType,
                        activeRecordKey: $activeRecordKey,
                        activeTime: $activeTime,
                        onTimePickerTap: handleTimePickerTap,
                        onSave: handleSaveRecord,
                        onDelete: handleDeleteRecord,
                        onFeedback: { rating in
                            handleFeedback(for: record, rating: rating)
                        },
                        onReasonSave: handleReasonSave
                    )

                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Overlay Views
    private var overlayViews: some View {
        ZStack {
            if showDatePicker {
                datePickerOverlay
            }
            
            if showTimePicker {
                timePickerOverlay
            }
            
            if showAlert {
                CustomAlertView(show: $showAlert)
            }
        }
    }
    
    // MARK: - Action Handlers
    private func handleGoButtonTap() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            return
        }
        
        if let startDate = tappedDate {
            viewModel.echeckallData.removeAll()
            viewModel.fetchOverallDetails(
                contactId: "\(contactID)",
                clientId: "\(clientID)",
                weekEnd: Date_Time_Formatter.APIformatDate(startDate),
                errorHandler: errorHandler
            )
        }
    }
    
    private func handleSubmitTap() {
        viewModel.overallSubmit(params: checkboxManager.submissionArray, errorHandler: errorHandler)
        
    }
    
    private func handleInfoTap() {
        withAnimation {
            showAlert.toggle()
        }
    }
    
    private func handleTimePickerTap(_ record: ECheckInAllResponse, _ timeType: TimeType) {
        switch timeType {
        case .start:
            activeRecordKey = record.checkIn
        case .end:
            activeRecordKey = record.checkOut
        }
        activeTimeType = timeType
        showTimePicker = true
    }
    
    // MARK: - Fixed Save Handler
    private func handleSaveRecord(_ record: ECheckInAllResponse) {
        print("Save button tapped for record: \(record.candidateName ?? "Unknown")")
        
        activeRecordForSave = record
        
        textFieldAlert = TextFieldAlert(
            title: "Save Record",
            message: "Enter reason for changing time:",
            placeholder: "Enter note..."
        ) { note in
            let noteText = note ?? ""
            
            viewModel.saveRecordDetails(
                response: record,
                contactId: String(config.contactID ?? 0),
                clientId: String(config.clientID ?? 0),
                checkin: record.checkIn,
                checkout: record.checkOut,
                note: noteText,
                errorHandler: errorHandler
            )
            
            refreshData()
            activeRecordForSave = nil
        }
    }
    
    // MARK: - Fixed Feedback Handler
//    private func handleFeedback(_ rating: Int) {
//        userRating = rating
//        
//        if rating <= 2 {
//            textFieldAlert = TextFieldAlert(
//                title: "Enter Feedback",
//                message: "",
//                placeholder: "Enter your feedback..."
//            ) { feedback in
//                let feedbackText = feedback ?? ""
//                savedRemark = feedbackText
//                
//                submitFeedback(rating: rating, feedback: feedbackText)
//            }
//        } else {
//            submitFeedback(rating: rating, feedback: "Good rating: \(rating)/5")
//        }
//    }
    private func handleFeedback(for record: ECheckInAllResponse, rating: Int) {
        recordRatings["\(record.id)"] = rating
        
        if rating <= 2 {
            textFieldAlert = TextFieldAlert(
                title: "Enter Feedback",
                message: "",
                placeholder: "Enter your feedback..."
            ) { feedback in
                let feedbackText = feedback ?? ""
                savedRemark = feedbackText
                submitFeedback(record: record, rating: rating, feedback: feedbackText)
            }
        } else {
            submitFeedback(record: record, rating: rating, feedback: "Good rating: \(rating)/5")
        }
    }

    
    private func submitFeedback(record: ECheckInAllResponse, rating: Int, feedback: String) {
        viewModel.fetchFeedbackDeatils(
            clientId: "\(config.clientID ?? 0)",
            weekEnd: record.weekEnd,
            rating: String(rating),
            source: String(rating),
            CandId: "\(record.candID)",
            OrderId: "\(record.orderID)",
            comments: feedback,
            ClientContacts: String(config.contactID ?? 0),
            errorHandler: errorHandler
        )
    }

    
    private func handleDeleteRecord(_ record: ECheckInAllResponse) {
        activeRecordForDeletion = record
        deleteCandidateName = record.candidateName ?? "this candidate"
        showDeleteAlert = true
    }
    
    private func performDelete(_ record: ECheckInAllResponse) {
        viewModel.deleteRecords(
            responseData: record,
            contactId: String(config.contactID ?? 0),
            clientId: String(config.clientID ?? 0),
            errorHandler: errorHandler
        )
        
        checkboxManager.removeRecord(record)
        activeRecordForDeletion = nil
        refreshData()
    }
    
    private func handleReasonSave(_ record: ECheckInAllResponse, _ reason: ReasonType, _ comment: String) {
        viewModel.selectReasonDetails(
            responseData: record,
            reasonID: record.id,
            reasonType: reason.rawValue,
            reasonComment: comment,
            ClientId: config.clientID ?? 0,
            ContactId: config.contactID ?? 0,
            errorHandler: errorHandler
        )
    }
    
    private func handleViewAppear() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else {
            errorHandler.showError(message: "Missing clientID or contactID", mode: .toast)
            return
        }
        
        viewModel.fetchOverallDetails(
            contactId: "\(contactID)",
            clientId: "\(clientID)",
            weekEnd: Date_Time_Formatter.APIformatDate(Date()),
            errorHandler: errorHandler
        )
        
        // Configure checkbox manager
        checkboxManager.configure(
            clientID: clientID,
            contactID: contactID,
            startTime: startSelectedTime,
            endTime: endSelectedTime
        )
    }
    
    private func refreshData() {
        guard let clientID = config.clientID,
              let contactID = config.contactID else { return }
        
        viewModel.fetchOverallDetails(
            contactId: String(contactID),
            clientId: String(clientID),
            weekEnd: Date_Time_Formatter.APIformatDate(startDate ?? Date()),
            errorHandler: errorHandler
        )
    }
    
    private func handleViewModelAlert() {
        // Handle ViewModel alerts if needed
        if let message = viewModel.alertMessage {
            print("ViewModel Alert: \(message)")
        }
    }
    
    // MARK: - Overlay Implementations
    private var datePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showDatePicker = false }
            
            VStack {
                Custom_Calander_View(
                    showDatePicker: $showDatePicker,
                    selectedDate: $selectedDate,
                    onDateSelection: { date in
                        selectedDate = date
                        startDate = date
                        tappedDate = date
                        showDatePicker = false
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
        }
        .zIndex(10)
    }
    
    private var timePickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { showTimePicker = false }
            
            Custom_Timer(
                showTimePicker: $showTimePicker,
                selectedTime: $activeTime
            ) { time in
                switch activeTimeType {
                case .start:
                    selectedStartTimes[activeRecordKey] = time
                    startSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                case .end:
                    selectedEndTimes[activeRecordKey] = time
                    endSelectedTime = Date_Time_Formatter.dateToApiString(time).toTimeAMPM() ?? ""
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .zIndex(10)
    }
}

// MARK: - Fixed RecordCardView with Star Rating
struct RecordCardViewFixed: View {
    let record: ECheckInAllResponse
    let index: Int
    let config: RecordCardConfig
    @ObservedObject var checkboxManager: CheckboxManager
    
    // Bindings for interactive elements
    @Binding var selectedStartTimes: [String: Time]
    @Binding var selectedEndTimes: [String: Time]
    @Binding var showReasonDropdown: [Int: Bool]
    @Binding var selectedReasons: [Int: ReasonType]
    @Binding var reasonComments: [Int: String]
    @Binding var userRating: Int
    @Binding var showTimePicker: Bool
    @Binding var activeTimeType: TimeType
    @Binding var activeRecordKey: String
    @Binding var activeTime: Time
    
    // Action callbacks
    let onTimePickerTap: (ECheckInAllResponse, TimeType) -> Void
    let onSave: (ECheckInAllResponse) -> Void
    let onDelete: (ECheckInAllResponse) -> Void
    let onFeedback: (Int) -> Void
    let onReasonSave: (ECheckInAllResponse, ReasonType, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if config.showCheckbox {
                RecordHeaderView(
                    record: record,
                    checkboxManager: checkboxManager
                )
            } else {
                BasicRecordHeader(record: record)
            }
            
            // Fixed Record Details with Star Rating
            RecordDetailsViewFixed(
                record: record,
                userRating: $userRating,
                showStarRating: config.showStarRating,
                onFeedback: { rating in
                        onFeedback(rating)
                    }
            )
            
            if config.showTimePickers && config.isEditable {
                TimePickersView(
                    record: record,
                    selectedStartTimes: selectedStartTimes,
                    selectedEndTimes: selectedEndTimes,
                    onTimePickerTap: onTimePickerTap
                )
            }
            
            if config.showReasonDropdown && config.isEditable {
                ReasonDropdownView(
                    record: record,
                    showReasonDropdown: $showReasonDropdown,
                    selectedReasons: $selectedReasons,
                    reasonComments: $reasonComments,
                    onReasonSave: onReasonSave
                )
            }
            
            if config.showActions && config.isEditable {
                RecordActionsView(
                    record: record,
                    onSave: { onSave(record) },
                    onDelete: { onDelete(record) }
                )
            }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Fixed Record Details with Star Rating
struct RecordDetailsViewFixed: View {
    let record: ECheckInAllResponse
    @Binding var userRating: Int
    let showStarRating: Bool
    let onFeedback: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showStarRating {
                StarRatingSectionFixed(
                    rating: $userRating,
                    onFeedback: onFeedback
                )
            }
            
            PositionView(record: record)
            ScheduleTimeView(record: record)
            TotalHoursView(record: record)
            BreakMinutesView(record: record)
        }
    }
}

// MARK: - Fixed Star Rating Section
struct StarRatingSectionFixed: View {
    @Binding var rating: Int
    let onFeedback: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            StarRatingView(rating: $rating) { newRating in
                onFeedback(newRating)
            }
            
            Button {
                onFeedback(rating)
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Enhanced CheckboxManager Configuration
extension CheckboxManager {
    func configure(clientID: Int, contactID: Int, startTime: String?, endTime: String?) {
        self.clientid = clientID
        self.contactid = contactID
        self.startSelectedTime = startTime
        self.endSelectedTime = endTime
        self.extraFields = [
            "clientId": clientID,
            "contactId": contactID,
            "startSelectedTime": startTime ?? "",
            "endSelectedTime": endTime ?? ""
        ]
    }
}
